// 로컬 Supabase(supabase start)에 실제로 붙어 저장소 쿼리·RLS·트리거를 확인한다.
// 로컬 Supabase가 꺼져 있으면 건너뛴다.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/error/app_failure.dart';
import 'package:job_tracker/features/postings/data/job_posting.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/data/posting_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<({String url, String key})?> _localSupabase() async {
  try {
    final result = await Process.run('supabase', [
      'status',
      '-o',
      'env',
    ], workingDirectory: '../..');
    if (result.exitCode != 0) return null;
    final env = <String, String>{
      for (final line in (result.stdout as String).split('\n'))
        if (line.contains('='))
          line.substring(0, line.indexOf('=')): line
              .substring(line.indexOf('=') + 1)
              .replaceAll('"', ''),
    };
    final url = env['API_URL'];
    final key = env['PUBLISHABLE_KEY'];
    if (url == null || key == null) return null;
    return (url: url, key: key);
  } on ProcessException {
    return null;
  }
}

Future<SupabaseClient> _signedInClient(({String url, String key}) local) async {
  final client = SupabaseClient(
    local.url,
    local.key,
    authOptions: const AuthClientOptions(
      autoRefreshToken: false,
      authFlowType: AuthFlowType.implicit,
    ),
  );
  final email = 'repo-${DateTime.now().microsecondsSinceEpoch}@test.local';
  await client.auth.signUp(email: email, password: 'password123');
  return client;
}

Future<void> main() async {
  final local = await _localSupabase();
  final skip = local == null ? '로컬 Supabase가 꺼져 있다(supabase start)' : null;

  late SupabaseClient client;
  late PostingRepository repository;

  setUp(() async {
    client = await _signedInClient(local!);
    repository = PostingRepository(client);
  });

  tearDown(() => client.dispose());

  test('등록 → 목록 → 수정 → 삭제', () async {
    final created = await repository.create(
      PostingDraft(
        company: '테스트회사',
        position: 'Flutter',
        channel: JobChannel.wanted,
        deadline: DateTime(2026, 12, 31),
      ),
    );
    expect(created.stage, ApplicationStage.interested);
    expect(created.deadline, DateTime(2026, 12, 31));

    expect((await repository.fetchAll()).map((p) => p.id), [created.id]);

    final updated = await repository.update(
      created.id,
      PostingDraft.fromPosting(created).copyWith(memo: '메모', deadline: null),
    );
    expect(updated.memo, '메모');
    expect(updated.deadline, isNull);

    await repository.delete(created.id);
    expect(await repository.fetchAll(), isEmpty);
    await expectLater(
      repository.fetch(created.id),
      throwsA(isA<NotFoundFailure>()),
    );
  }, skip: skip);

  test('단계를 바꾸면 이력이 쌓이고, 이전 단계보다 빠른 날짜는 거부된다', () async {
    final posting = await repository.create(
      const PostingDraft(company: '이력회사', position: '앱'),
    );

    final applied = await repository.changeStage(
      posting.id,
      ApplicationStage.applied,
    );
    expect(applied.stage, ApplicationStage.applied);

    final events = await repository.fetchEvents(postingId: posting.id);
    expect(events.map((e) => (e.fromStage, e.toStage)), [
      (null, ApplicationStage.interested),
      (ApplicationStage.interested, ApplicationStage.applied),
    ]);

    await expectLater(
      repository.changeStage(
        posting.id,
        ApplicationStage.viewed,
        at: DateTime(2020),
      ),
      throwsA(isA<StageDateRejectedFailure>()),
    );
  }, skip: skip);

  test('다른 사람 공고는 목록에 안 보이고 상세 조회도 실패한다', () async {
    final other = await _signedInClient(local!);
    final otherPosting = await PostingRepository(other)
        .create(const PostingDraft(company: '남의회사', position: 'x'));
    other.dispose();

    expect(
      (await repository.fetchAll()).where((p) => p.id == otherPosting.id),
      isEmpty,
    );
    await expectLater(
      repository.fetch(otherPosting.id),
      throwsA(isA<NotFoundFailure>()),
    );
  }, skip: skip);
}
