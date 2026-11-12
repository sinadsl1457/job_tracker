import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/postings/data/funnel_stats.dart';
import 'package:job_tracker/features/postings/data/job_posting.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';

typedef S = ApplicationStage;

/// 공고 하나가 거친 단계들을 이력으로 만든다.
List<StageEvent> path(String postingId, List<S> stages) => [
  for (var i = 0; i < stages.length; i++)
    StageEvent(
      id: i,
      postingId: postingId,
      fromStage: i == 0 ? null : stages[i - 1],
      toStage: stages[i],
      changedAt: DateTime(2026, 11, 1 + i),
    ),
];

void main() {
  test('이력이 없으면 모두 0, 비율은 null(0%와 구분)', () {
    final stats = FunnelStats.fromEvents([]);
    expect(stats.applied, 0);
    expect(stats.viewRate, isNull);
    expect(stats.interviewRate, isNull);
  });

  test('기본 계산: 지원 4 → 열람 3 → 서류 2 → 면접 1', () {
    final stats = FunnelStats.fromEvents([
      ...path('a', [S.interested, S.applied]),
      ...path('b', [S.interested, S.applied, S.viewed]),
      ...path('c', [S.interested, S.applied, S.viewed, S.docPassed]),
      ...path('d', [S.applied, S.viewed, S.docPassed, S.interview1]),
      ...path('e', [S.interested]),
    ]);
    expect(
      (stats.applied, stats.viewed, stats.docPassed, stats.interviewed),
      (4, 3, 2, 1),
    );
    expect(stats.viewRate, 0.75);
    expect(stats.docPassRate, 0.5);
    expect(stats.interviewRate, 0.5);
  });

  test('단계를 왔다 갔다 해도 공고 하나는 한 번만 센다', () {
    final stats = FunnelStats.fromEvents(
      path('a', [S.interested, S.applied, S.viewed, S.applied, S.viewed]),
    );
    expect((stats.applied, stats.viewed), (1, 1));
  });

  test('열람 없이 서류합격으로 건너뛰어도 열람까지 도달한 것으로 센다', () {
    final stats = FunnelStats.fromEvents(path('a', [S.applied, S.docPassed]));
    expect((stats.applied, stats.viewed, stats.docPassed), (1, 1, 1));
  });

  test('불합격·보류가 돼도 그전까지 도달한 단계로 센다', () {
    final stats = FunnelStats.fromEvents([
      ...path('a', [S.applied, S.viewed, S.rejected]),
      ...path('b', [S.applied, S.onHold]),
    ]);
    expect((stats.applied, stats.viewed, stats.docPassed), (2, 1, 0));
  });
}
