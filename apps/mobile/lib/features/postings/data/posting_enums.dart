// DB enum과 1:1로 맞춘다(supabase/migrations/..._create_tables.sql).
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'dbValue')
enum ApplicationStage {
  interested('interested', '관심', 0),
  applied('applied', '지원', 1),
  viewed('viewed', '열람', 2),
  docPassed('doc_passed', '서류합격', 3),
  assignment('assignment', '과제', 4),
  interview1('interview_1', '1차면접', 5),
  interview2('interview_2', '2차면접', 6),
  finalPassed('final_passed', '최종합격', 7),
  rejected('rejected', '불합격', null),
  onHold('on_hold', '보류', null);

  const ApplicationStage(this.dbValue, this.label, this.progress);

  final String dbValue;
  final String label;

  /// 진행 순서. 불합격·보류는 순서 밖이라 null.
  final int? progress;

  /// 이 단계에 있으면 [other] 단계까지 왔다고 본다(건너뛴 단계 포함).
  bool hasReached(ApplicationStage other) =>
      progress != null &&
      other.progress != null &&
      progress! >= other.progress!;
}

@JsonEnum(valueField: 'dbValue')
enum JobChannel {
  jobkorea('jobkorea', '잡코리아'),
  wanted('wanted', '원티드'),
  saramin('saramin', '사람인'),
  other('other', '기타');

  const JobChannel(this.dbValue, this.label);

  final String dbValue;
  final String label;
}

@JsonEnum(valueField: 'dbValue')
enum EmploymentType {
  fullTime('full_time', '정규직'),
  contract('contract', '계약직'),
  intern('intern', '인턴'),
  freelance('freelance', '프리랜서'),
  other('other', '기타');

  const EmploymentType(this.dbValue, this.label);

  final String dbValue;
  final String label;
}
