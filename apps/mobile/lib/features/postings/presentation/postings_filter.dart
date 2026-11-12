// 목록 필터 상태와, 필터·정렬·D-day 계산(순수 함수).
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/job_posting.dart';
import '../data/posting_enums.dart';

part 'postings_filter.freezed.dart';

enum PostingSort {
  deadlineSoon('마감 임박순'),
  recentlyChanged('최근 변경순'),
  recentlyCreated('최근 등록순');

  const PostingSort(this.label);

  final String label;
}

@freezed
abstract class PostingsFilter with _$PostingsFilter {
  const factory PostingsFilter({
    ApplicationStage? stage,
    JobChannel? channel,
    @Default(PostingSort.deadlineSoon) PostingSort sort,
  }) = _PostingsFilter;
}

List<JobPosting> applyPostingsFilter(
  List<JobPosting> postings,
  PostingsFilter filter, {
  required DateTime today,
}) {
  final result = postings
      .where((p) => filter.stage == null || p.stage == filter.stage)
      .where((p) => filter.channel == null || p.channel == filter.channel)
      .toList();

  int newestFirst(DateTime a, DateTime b) => b.compareTo(a);

  switch (filter.sort) {
    case PostingSort.recentlyCreated:
      result.sort((a, b) => newestFirst(a.createdAt, b.createdAt));
    case PostingSort.recentlyChanged:
      result.sort((a, b) => newestFirst(a.stageChangedAt, b.stageChangedAt));
    case PostingSort.deadlineSoon:
      // 남은 마감(가까운 순) → 마감일 없음 → 지난 마감(최근에 지난 순)
      int group(JobPosting p) {
        final days = daysUntil(p.deadline, today);
        if (days == null) return 1;
        return days >= 0 ? 0 : 2;
      }

      result.sort((a, b) {
        final byGroup = group(a).compareTo(group(b));
        if (byGroup != 0) return byGroup;
        return switch (group(a)) {
          0 => a.deadline!.compareTo(b.deadline!),
          2 => newestFirst(a.deadline!, b.deadline!),
          _ => newestFirst(a.createdAt, b.createdAt),
        };
      });
  }
  return result;
}

/// 마감까지 남은 날짜 수. 오늘 마감이면 0, 지났으면 음수.
int? daysUntil(DateTime? deadline, DateTime today) {
  if (deadline == null) return null;
  // 날짜만 비교한다. 시각·서머타임이 끼지 않게 UTC 자정끼리 뺀다.
  final d = DateTime.utc(deadline.year, deadline.month, deadline.day);
  final t = DateTime.utc(today.year, today.month, today.day);
  return d.difference(t).inDays;
}

String? deadlineLabel(DateTime? deadline, DateTime today) {
  final days = daysUntil(deadline, today);
  if (days == null) return null;
  if (days < 0) return '마감';
  if (days == 0) return 'D-day';
  return 'D-$days';
}
