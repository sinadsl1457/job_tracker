// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_posting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobPosting _$JobPostingFromJson(Map<String, dynamic> json) => _JobPosting(
  id: json['id'] as String,
  company: json['company'] as String,
  position: json['position'] as String,
  url: json['url'] as String?,
  channel: $enumDecode(_$JobChannelEnumMap, json['channel']),
  deadline: _$JsonConverterFromJson<String, DateTime>(
    json['deadline'],
    const DateOnlyConverter().fromJson,
  ),
  location: json['location'] as String?,
  employmentType: $enumDecodeNullable(
    _$EmploymentTypeEnumMap,
    json['employment_type'],
  ),
  memo: json['memo'] as String?,
  stage: $enumDecode(_$ApplicationStageEnumMap, json['stage']),
  stageChangedAt: DateTime.parse(json['stage_changed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$JobPostingToJson(_JobPosting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company': instance.company,
      'position': instance.position,
      'url': instance.url,
      'channel': _$JobChannelEnumMap[instance.channel]!,
      'deadline': _$JsonConverterToJson<String, DateTime>(
        instance.deadline,
        const DateOnlyConverter().toJson,
      ),
      'location': instance.location,
      'employment_type': _$EmploymentTypeEnumMap[instance.employmentType],
      'memo': instance.memo,
      'stage': _$ApplicationStageEnumMap[instance.stage]!,
      'stage_changed_at': instance.stageChangedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$JobChannelEnumMap = {
  JobChannel.jobkorea: 'jobkorea',
  JobChannel.wanted: 'wanted',
  JobChannel.saramin: 'saramin',
  JobChannel.other: 'other',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$EmploymentTypeEnumMap = {
  EmploymentType.fullTime: 'full_time',
  EmploymentType.contract: 'contract',
  EmploymentType.intern: 'intern',
  EmploymentType.freelance: 'freelance',
  EmploymentType.other: 'other',
};

const _$ApplicationStageEnumMap = {
  ApplicationStage.interested: 'interested',
  ApplicationStage.applied: 'applied',
  ApplicationStage.viewed: 'viewed',
  ApplicationStage.docPassed: 'doc_passed',
  ApplicationStage.assignment: 'assignment',
  ApplicationStage.interview1: 'interview_1',
  ApplicationStage.interview2: 'interview_2',
  ApplicationStage.finalPassed: 'final_passed',
  ApplicationStage.rejected: 'rejected',
  ApplicationStage.onHold: 'on_hold',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_StageEvent _$StageEventFromJson(Map<String, dynamic> json) => _StageEvent(
  id: (json['id'] as num).toInt(),
  postingId: json['posting_id'] as String,
  fromStage: $enumDecodeNullable(_$ApplicationStageEnumMap, json['from_stage']),
  toStage: $enumDecode(_$ApplicationStageEnumMap, json['to_stage']),
  changedAt: DateTime.parse(json['changed_at'] as String),
);

Map<String, dynamic> _$StageEventToJson(_StageEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'posting_id': instance.postingId,
      'from_stage': _$ApplicationStageEnumMap[instance.fromStage],
      'to_stage': _$ApplicationStageEnumMap[instance.toStage]!,
      'changed_at': instance.changedAt.toIso8601String(),
    };
