import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/error/app_failure.dart';
import 'package:job_tracker/core/riverpod/app_retry.dart';
import 'package:job_tracker/core/time/clock.dart';
import 'package:job_tracker/features/posting_form/presentation/posting_form_screen.dart';
import 'package:job_tracker/features/postings/data/posting_providers.dart';
import 'package:job_tracker/features/postings/presentation/postings_screen.dart';

import '../../helpers/fake_posting_repository.dart';

void main() {
  late FakePostingRepository repository;

  Future<void> pumpApp(
    WidgetTester tester, {
    String initial = '/postings',
  }) async {
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: '/postings',
          builder: (_, _) => const PostingsScreen(),
          routes: [
            GoRoute(path: 'new', builder: (_, _) => const PostingFormScreen()),
            GoRoute(
              path: ':id/edit',
              builder: (_, state) =>
                  PostingFormScreen(postingId: state.pathParameters['id']),
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

  testWidgets('필수 칸을 비우면 저장하지 않고, 채우면 등록 후 목록에 보인다', (tester) async {
    repository = FakePostingRepository();
    await pumpApp(tester);

    await tester.tap(find.byTooltip('공고 등록'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    expect(find.text('회사명을(를) 입력해 주세요.'), findsOneWidget);
    expect(repository.calls.where((c) => c.startsWith('create')), isEmpty);

    await tester.enterText(find.byKey(const Key('form-company')), '참새랩');
    await tester.enterText(find.byKey(const Key('form-position')), '앱 개발');
    await tester.enterText(find.byKey(const Key('form-url')), 'wanted.co.kr/1');
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    expect(find.textContaining('http:// 또는 https://'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('form-url')),
      'https://wanted.co.kr/1',
    );
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.calls, contains('create:참새랩'));
    expect(find.byType(PostingsScreen), findsOneWidget);
    expect(find.text('참새랩 · 앱 개발'), findsOneWidget);
  });

  testWidgets('저장이 실패하면 화면에 남아 입력을 잃지 않는다', (tester) async {
    repository = FakePostingRepository();
    await pumpApp(tester, initial: '/postings/new');

    await tester.enterText(find.byKey(const Key('form-company')), '참새랩');
    await tester.enterText(find.byKey(const Key('form-position')), '앱 개발');
    repository.failNext = const NetworkFailure();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.textContaining('서버에 연결하지 못했습니다'), findsOneWidget);
    expect(find.byType(PostingFormScreen), findsOneWidget);
    expect(find.text('참새랩'), findsOneWidget);
  });

  testWidgets('수정 화면은 기존 값을 불러와 채운다', (tester) async {
    repository = FakePostingRepository([posting('1', company: '토끼마켓')]);
    await pumpApp(tester, initial: '/postings/1/edit');

    expect(find.text('공고 수정'), findsOneWidget);
    expect(find.text('토끼마켓'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('form-company')), '토끼마켓2');
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    expect(repository.calls, contains('update:1'));
  });
}
