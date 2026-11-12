// 공고 상세(공고 + 단계 이력). 공고 id마다 따로 생긴다.
import 'package:flutter/material.dart' show DateUtils;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/time/clock.dart';
import '../../postings/data/job_posting.dart';
import '../../postings/data/posting_enums.dart';
import '../../postings/data/posting_providers.dart';
import '../data/stage_change_rule.dart';

part 'posting_detail_notifier.freezed.dart';
part 'posting_detail_notifier.g.dart';

@freezed
abstract class PostingDetail with _$PostingDetail {
  const factory PostingDetail({
    required JobPosting posting,
    required List<StageEvent> events,
  }) = _PostingDetail;
}

@riverpod
class PostingDetailNotifier extends _$PostingDetailNotifier {
  @override
  Future<PostingDetail> build(String postingId) async {
    final repository = ref.watch(postingRepositoryProvider);
    final (posting, events) = await (
      repository.fetch(postingId),
      repository.fetchEvents(postingId: postingId),
    ).wait;
    return PostingDetail(posting: posting, events: events);
  }

  /// 실패하면 AppFailure를 던진다(규칙 위반은 서버를 부르지 않고 StageChangeFailure).
  Future<void> changeStage(ApplicationStage next, DateTime pickedDate) async {
    final current = state.requireValue.posting;
    final now = ref.read(clockProvider).now();
    final at = stageChangeTime(pickedDate, now);
    final error = checkStageChange(
      current: current.stage,
      next: next,
      at: at,
      lastChangedAt: current.stageChangedAt,
      now: now,
    );
    if (error != null) throw StageChangeFailure(error);

    final repository = ref.read(postingRepositoryProvider);
    // 오늘이면 시각을 보내지 않고 DB 시계를 쓴다(기기 시계가 틀려도 미래로 거부되지 않게).
    final isToday = DateUtils.isSameDay(pickedDate, now);
    final updated = await repository.changeStage(
      postingId,
      next,
      at: isToday ? null : at,
    );
    final events = await repository.fetchEvents(postingId: postingId);
    if (!ref.mounted) return;
    state = AsyncData(PostingDetail(posting: updated, events: events));
    ref
      ..invalidate(postingsProvider)
      ..invalidate(allStageEventsProvider);
  }

  Future<void> delete() async {
    await ref.read(postingRepositoryProvider).delete(postingId);
    if (!ref.mounted) return;
    ref
      ..invalidate(postingsProvider)
      ..invalidate(allStageEventsProvider);
  }
}
