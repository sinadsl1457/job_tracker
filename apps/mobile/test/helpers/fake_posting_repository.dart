import 'dart:async';

import 'package:job_tracker/core/error/app_failure.dart';
import 'package:job_tracker/features/postings/data/job_posting.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/data/posting_repository.dart';

final testNow = DateTime(2026, 11, 12, 10);

JobPosting posting(
  String id, {
  String? company,
  JobChannel channel = JobChannel.other,
  ApplicationStage stage = ApplicationStage.interested,
  DateTime? deadline,
  DateTime? createdAt,
  DateTime? stageChangedAt,
}) {
  final created = createdAt ?? DateTime(2026, 11, 1);
  return JobPosting(
    id: id,
    company: company ?? '회사$id',
    position: '포지션$id',
    channel: channel,
    deadline: deadline,
    stage: stage,
    stageChangedAt: stageChangedAt ?? created,
    createdAt: created,
    updatedAt: created,
  );
}

/// 메모리에서 동작하는 저장소. DB 트리거처럼 단계를 바꾸면 이력을 남긴다.
class FakePostingRepository implements PostingRepository {
  FakePostingRepository([List<JobPosting> initial = const []])
    : _postings = {for (final p in initial) p.id: p};

  final Map<String, JobPosting> _postings;
  final events = <StageEvent>[];
  final calls = <String>[];

  /// 다음 호출을 실패시킨다.
  AppFailure? failNext;

  /// 설정하면 fetchAll이 이 Completer를 기다린다(로딩 화면 확인용).
  Completer<void>? hold;

  int _nextId = 1000;

  Future<void> _maybeFail() async {
    if (hold != null) await hold!.future;
    final failure = failNext;
    if (failure != null) {
      failNext = null;
      throw failure;
    }
  }

  @override
  Future<List<JobPosting>> fetchAll() async {
    calls.add('fetchAll');
    await _maybeFail();
    return _postings.values.toList();
  }

  @override
  Future<JobPosting> fetch(String id) async {
    calls.add('fetch:$id');
    await _maybeFail();
    return _postings[id] ?? (throw const NotFoundFailure());
  }

  @override
  Future<List<StageEvent>> fetchEvents({String? postingId}) async {
    calls.add('fetchEvents:${postingId ?? 'all'}');
    await _maybeFail();
    return events
        .where((e) => postingId == null || e.postingId == postingId)
        .toList();
  }

  @override
  Future<JobPosting> create(PostingDraft draft) async {
    calls.add('create:${draft.company}');
    await _maybeFail();
    final id = 'new${_nextId++}';
    final created = JobPosting(
      id: id,
      company: draft.company.trim(),
      position: draft.position.trim(),
      url: draft.url,
      channel: draft.channel,
      deadline: draft.deadline,
      location: draft.location,
      employmentType: draft.employmentType,
      memo: draft.memo,
      stage: ApplicationStage.interested,
      stageChangedAt: testNow,
      createdAt: testNow,
      updatedAt: testNow,
    );
    _postings[id] = created;
    _record(id, null, ApplicationStage.interested, testNow);
    return created;
  }

  @override
  Future<JobPosting> update(String id, PostingDraft draft) async {
    calls.add('update:$id');
    await _maybeFail();
    final updated = _postings[id]!.copyWith(
      company: draft.company.trim(),
      position: draft.position.trim(),
      url: draft.url,
      channel: draft.channel,
      deadline: draft.deadline,
      location: draft.location,
      employmentType: draft.employmentType,
      memo: draft.memo,
    );
    _postings[id] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    calls.add('delete:$id');
    await _maybeFail();
    _postings.remove(id);
    events.removeWhere((e) => e.postingId == id);
  }

  @override
  Future<JobPosting> changeStage(
    String id,
    ApplicationStage stage, {
    DateTime? at,
  }) async {
    calls.add('changeStage:$id:${stage.dbValue}');
    await _maybeFail();
    final before = _postings[id]!;
    final when = at ?? testNow;
    final updated = before.copyWith(stage: stage, stageChangedAt: when);
    _postings[id] = updated;
    _record(id, before.stage, stage, when);
    return updated;
  }

  void _record(
    String id,
    ApplicationStage? from,
    ApplicationStage to,
    DateTime at,
  ) {
    events.add(
      StageEvent(
        id: events.length + 1,
        postingId: id,
        fromStage: from,
        toStage: to,
        changedAt: at,
      ),
    );
  }
}
