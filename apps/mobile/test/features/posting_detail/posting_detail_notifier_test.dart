import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/error/app_failure.dart';
import 'package:job_tracker/core/riverpod/app_retry.dart';
import 'package:job_tracker/core/time/clock.dart';
import 'package:job_tracker/features/posting_detail/data/stage_change_rule.dart';
import 'package:job_tracker/features/posting_detail/presentation/posting_detail_notifier.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/data/posting_providers.dart';

import '../../helpers/fake_posting_repository.dart';

void main() {
  late FakePostingRepository repository;
  late ProviderContainer container;

  setUp(() async {
    repository = FakePostingRepository([
      posting(
        '1',
        stage: ApplicationStage.applied,
        stageChangedAt: DateTime(2026, 11, 5, 9),
      ),
    ]);
    container = ProviderContainer.test(
      retry: appRetry,
      overrides: [
        postingRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(FixedClock(testNow)),
      ],
    );
    // 아무도 안 보면 autoDispose가 정리하므로 화면처럼 계속 본다.
    container.listen(postingDetailProvider('1'), (_, _) {});
    await container.read(postingDetailProvider('1').future);
    repository.calls.clear();
  });

  PostingDetailNotifier notifier() =>
      container.read(postingDetailProvider('1').notifier);

  test('오늘로 바꾸면 시각을 보내지 않고(DB 시계), 상태가 새 단계와 이력으로 바뀐다', () async {
    await notifier().changeStage(
      ApplicationStage.viewed,
      DateTime(2026, 11, 12),
    );

    final detail = container.read(postingDetailProvider('1')).requireValue;
    expect(detail.posting.stage, ApplicationStage.viewed);
    expect(detail.events.last.toStage, ApplicationStage.viewed);
    expect(repository.calls, ['changeStage:1:viewed', 'fetchEvents:1']);
  });

  test('지난 날로 바꾸면 그날 23:59로 저장한다', () async {
    await notifier().changeStage(
      ApplicationStage.viewed,
      DateTime(2026, 11, 8),
    );

    final detail = container.read(postingDetailProvider('1')).requireValue;
    expect(detail.posting.stageChangedAt, DateTime(2026, 11, 8, 23, 59));
  });

  test('이전 단계보다 빠른 날짜는 서버를 부르지 않고 거부한다', () async {
    await expectLater(
      notifier().changeStage(ApplicationStage.viewed, DateTime(2026, 11, 1)),
      throwsA(
        isA<StageChangeFailure>().having(
          (f) => f.error,
          'error',
          StageChangeError.beforeLastChange,
        ),
      ),
    );
    expect(repository.calls, isEmpty);
  });

  test('서버가 실패하면 기존 상태를 유지한다', () async {
    repository.failNext = const NetworkFailure();
    await expectLater(
      notifier().changeStage(ApplicationStage.viewed, DateTime(2026, 11, 12)),
      throwsA(isA<NetworkFailure>()),
    );
    final detail = container.read(postingDetailProvider('1')).requireValue;
    expect(detail.posting.stage, ApplicationStage.applied);
  });

  test('단계를 바꾸면 목록도 다시 불러온다', () async {
    container.listen(postingsProvider, (_, _) {});
    await container.read(postingsProvider.future);
    repository.calls.clear();

    await notifier().changeStage(
      ApplicationStage.viewed,
      DateTime(2026, 11, 12),
    );
    await container.read(postingsProvider.future);

    expect(repository.calls, contains('fetchAll'));
    expect(
      container.read(postingsProvider).requireValue.single.stage,
      ApplicationStage.viewed,
    );
  });
}
