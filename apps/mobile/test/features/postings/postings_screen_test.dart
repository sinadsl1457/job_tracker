import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/error/app_failure.dart';
import 'package:job_tracker/core/riverpod/app_retry.dart';
import 'package:job_tracker/core/time/clock.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/data/posting_providers.dart';
import 'package:job_tracker/features/postings/presentation/postings_screen.dart';

import '../../helpers/fake_posting_repository.dart';

void main() {
  late FakePostingRepository repository;

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: appRetry,
        overrides: [
          postingRepositoryProvider.overrideWithValue(repository),
          clockProvider.overrideWithValue(FixedClock(testNow)),
        ],
        child: const MaterialApp(home: PostingsScreen()),
      ),
    );
  }

  testWidgets('불러오는 동안 로딩, 끝나면 마감 임박순으로 D-day와 함께 보인다', (tester) async {
    repository = FakePostingRepository([
      posting(
        '1',
        company: '토끼마켓',
        channel: JobChannel.wanted,
        deadline: DateTime(2026, 11, 13),
      ),
      posting(
        '2',
        company: '거북페이',
        channel: JobChannel.saramin,
        stage: ApplicationStage.applied,
      ),
      posting(
        '3',
        company: '고래헬스',
        channel: JobChannel.wanted,
        deadline: DateTime(2026, 11, 20),
      ),
    ])..hold = Completer();
    await pumpScreen(tester);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.hold!.complete();
    await tester.pumpAndSettle();

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title! as Text).data)
        .toList();
    expect(titles, ['토끼마켓 · 포지션1', '고래헬스 · 포지션3', '거북페이 · 포지션2']);
    expect(find.textContaining('D-1'), findsOneWidget);
    expect(find.textContaining('D-8'), findsOneWidget);
  });

  testWidgets('채널 칩을 누르면 그 채널만, 다시 누르면 전체', (tester) async {
    repository = FakePostingRepository([
      posting('1', company: '토끼마켓', channel: JobChannel.wanted),
      posting('2', company: '거북페이', channel: JobChannel.saramin),
    ]);
    await pumpScreen(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, '사람인'));
    await tester.pumpAndSettle();
    expect(find.textContaining('거북페이'), findsOneWidget);
    expect(find.textContaining('토끼마켓'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, '사람인'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('연결 실패면 안내와 다시 시도, 누르면 다시 불러온다', (tester) async {
    repository = FakePostingRepository([posting('1', company: '토끼마켓')])
      ..failNext = const NetworkFailure();
    await pumpScreen(tester);
    await tester.pumpAndSettle();

    expect(find.textContaining('서버에 연결하지 못했습니다'), findsOneWidget);
    expect(
      repository.calls.where((c) => c == 'fetchAll'),
      hasLength(1),
      reason: '자동 재시도 없음',
    );

    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.textContaining('토끼마켓'), findsOneWidget);
  });

  testWidgets('공고가 없으면 빈 화면 안내', (tester) async {
    repository = FakePostingRepository();
    await pumpScreen(tester);
    await tester.pumpAndSettle();
    expect(find.textContaining('아직 등록한 공고가 없습니다'), findsOneWidget);
  });
}
