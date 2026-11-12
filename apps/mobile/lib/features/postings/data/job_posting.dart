// 공고(읽기용), 공고 입력값(쓰기용), 단계 이력.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'posting_enums.dart';

part 'job_posting.freezed.dart';
part 'job_posting.g.dart';

@freezed
abstract class JobPosting with _$JobPosting {
  const factory JobPosting({
    required String id,
    required String company,
    required String position,
    String? url,
    required JobChannel channel,
    @DateOnlyConverter() DateTime? deadline,
    String? location,
    EmploymentType? employmentType,
    String? memo,
    required ApplicationStage stage,
    required DateTime stageChangedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JobPosting;

  factory JobPosting.fromJson(Map<String, dynamic> json) =>
      _$JobPostingFromJson(json);
}

/// 등록·수정 화면이 만드는 값. id·단계·시각은 DB가 정한다.
@freezed
abstract class PostingDraft with _$PostingDraft {
  const PostingDraft._();

  const factory PostingDraft({
    @Default('') String company,
    @Default('') String position,
    String? url,
    @Default(JobChannel.other) JobChannel channel,
    DateTime? deadline,
    String? location,
    EmploymentType? employmentType,
    String? memo,
  }) = _PostingDraft;

  factory PostingDraft.fromPosting(JobPosting p) => PostingDraft(
    company: p.company,
    position: p.position,
    url: p.url,
    channel: p.channel,
    deadline: p.deadline,
    location: p.location,
    employmentType: p.employmentType,
    memo: p.memo,
  );

  /// insert/update 본문. 빈 칸은 null로 보내서 "지운 값"도 저장되게 한다.
  Map<String, dynamic> toRow() => {
    'company': company.trim(),
    'position': position.trim(),
    'url': _blankToNull(url),
    'channel': channel.dbValue,
    'deadline': deadline == null
        ? null
        : const DateOnlyConverter().toJson(deadline!),
    'location': _blankToNull(location),
    'employment_type': employmentType?.dbValue,
    'memo': _blankToNull(memo),
  };

  static String? _blankToNull(String? v) =>
      (v == null || v.trim().isEmpty) ? null : v.trim();
}

@freezed
abstract class StageEvent with _$StageEvent {
  const factory StageEvent({
    required int id,
    required String postingId,
    ApplicationStage? fromStage,
    required ApplicationStage toStage,
    required DateTime changedAt,
  }) = _StageEvent;

  factory StageEvent.fromJson(Map<String, dynamic> json) =>
      _$StageEventFromJson(json);
}

/// DB `date` 컬럼 ↔ 현지 자정 DateTime. 시각·시간대가 끼면 하루가 밀린다.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) {
    final parts = json.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  @override
  String toJson(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
