// 지원 전환율. 공고마다 "한 번이라도 도달한 가장 먼 단계"로 센다.
// 단계를 왔다 갔다 해도 부풀지 않고, 불합격·보류가 된 공고도 그전까지 도달한 단계로 센다.
// 웹 대시보드(apps/web)와 같은 정의를 쓴다.
import 'job_posting.dart';
import 'posting_enums.dart';

class FunnelStats {
  const FunnelStats({
    required this.applied,
    required this.viewed,
    required this.docPassed,
    required this.interviewed,
  });

  factory FunnelStats.fromEvents(Iterable<StageEvent> events) {
    final furthest = <String, int>{};
    for (final e in events) {
      final progress = e.toStage.progress;
      if (progress == null) continue;
      final before = furthest[e.postingId];
      if (before == null || progress > before) {
        furthest[e.postingId] = progress;
      }
    }
    int reached(ApplicationStage stage) =>
        furthest.values.where((p) => p >= stage.progress!).length;

    return FunnelStats(
      applied: reached(ApplicationStage.applied),
      viewed: reached(ApplicationStage.viewed),
      docPassed: reached(ApplicationStage.docPassed),
      interviewed: reached(ApplicationStage.interview1),
    );
  }

  /// 지원 이상에 도달한 공고 수
  final int applied;
  final int viewed;
  final int docPassed;

  /// 1차면접 이상
  final int interviewed;

  /// 분모가 0이면 null(0%와 구분).
  double? get viewRate => _ratio(viewed, applied);
  double? get docPassRate => _ratio(docPassed, applied);
  double? get interviewRate => _ratio(interviewed, docPassed);

  static double? _ratio(int part, int whole) =>
      whole == 0 ? null : part / whole;
}
