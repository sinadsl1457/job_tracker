// 단계 변경 규칙. DB 트리거(job_postings_before_write)와 같은 규칙을 저장 전에 미리 확인한다.
import '../../../core/error/app_failure.dart';
import '../../postings/data/posting_enums.dart';

enum StageChangeError {
  sameStage('지금과 같은 단계입니다.'),
  beforeLastChange('이전 단계로 바뀐 날보다 빠를 수 없습니다.'),
  future('오늘 이후 날짜는 고를 수 없습니다.');

  const StageChangeError(this.message);

  final String message;
}

final class StageChangeFailure extends AppFailure {
  const StageChangeFailure(this.error);

  final StageChangeError error;

  @override
  String get message => error.message;
}

/// 고른 날짜를 저장할 시각으로 바꾼다.
/// 오늘이면 지금 시각, 지난 날이면 그날 23:59(같은 날 여러 번 바꿔도 이전 단계보다 빠르지 않게).
DateTime stageChangeTime(DateTime pickedDate, DateTime now) {
  final isToday =
      pickedDate.year == now.year &&
      pickedDate.month == now.month &&
      pickedDate.day == now.day;
  if (isToday) return now;
  return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59);
}

StageChangeError? checkStageChange({
  required ApplicationStage current,
  required ApplicationStage next,
  required DateTime at,
  required DateTime lastChangedAt,
  required DateTime now,
}) {
  if (current == next) return StageChangeError.sameStage;
  if (at.isAfter(now)) return StageChangeError.future;
  if (at.isBefore(lastChangedAt)) return StageChangeError.beforeLastChange;
  return null;
}
