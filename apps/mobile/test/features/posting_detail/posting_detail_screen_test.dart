import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/riverpod/app_retry.dart';
import 'package:job_tracker/core/time/clock.dart';
import 'package:job_tracker/features/posting_detail/presentation/posting_detail_screen.dart';
import 'package:job_tracker/features/postings/data/job_posting.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/data/posting_providers.dart';
import 'package:job_tracker/features/postings/presentation/postings_screen.dart';

import '../../helpers/fake_posting_repository.dart';

void main() {
  late FakePostingRepository repository;
  late String createdId;

  Future<void> pumpApp(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/postings',
      routes: [
        GoRoute(
          path: '/postings',
          builder: (_, _) => const PostingsScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) =>
                  PostingDetailScreen(postingId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        retry: appRetry,
        overrides: [
          postingRepositoryProvider.overrideWithValue(repository),
          clockProvider.overrideWithValue(FixedClock(testNow)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() async {
    repository = FakePostingRepository();
    final created = await repository.create(
      const PostingDraft(company: '토끼마켓', position: 'Flutter'),
    );
    repository.calls.clear();
    createdId = created.id;
  });

  testWidgets('목록 → 상세 → 단계 변경 → 이력과 목록이 함께 바뀐다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('토끼마켓 · Flutter'));
    await tester.pumpAndSettle();
    expect(find.text('관심 (등록)'), findsOneWidget);

    await tester.tap(find.text('단계 변경'));
    await tester.pumpAndSettle();
    final interestedChip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, '관심'),
    );
    expect(interestedChip.onSelected, isNull, reason: '지금 단계는 고를 수 없다');

    await tester.tap(find.widgetWithText(ChoiceChip, '지원'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '변경'));
    await tester.pumpAndSettle();

    expect(repository.calls, contains('changeStage:$createdId:applied'));
    expect(find.text('관심 → 지원'), findsOneWidget);
    expect(find.text('지원(으)로 바꿨습니다.'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    final tile = find.ancestor(
      of: find.text('토끼마켓 · Flutter'),
      matching: find.byType(ListTile),
    );
    expect(
      find.descendant(
        of: tile,
        matching: find.text(ApplicationStage.applied.label),
      ),
      findsOneWidget,
    );
  });

  testWidgets('삭제를 확인하면 목록으로 돌아가고 공고가 사라진다', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('토끼마켓 · Flutter'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('삭제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();

    expect(repository.calls, contains('delete:$createdId'));
    expect(find.byType(PostingsScreen), findsOneWidget);
    expect(find.textContaining('아직 등록한 공고가 없습니다'), findsOneWidget);
  });
}
