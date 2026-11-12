import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/posting_enums.dart';
import 'postings_filter.dart';

part 'postings_filter_notifier.g.dart';

@riverpod
class PostingsFilterNotifier extends _$PostingsFilterNotifier {
  @override
  PostingsFilter build() => const PostingsFilter();

  void setStage(ApplicationStage? stage) =>
      state = state.copyWith(stage: stage);

  /// 이미 고른 채널을 다시 누르면 해제한다.
  void toggleChannel(JobChannel channel) => state = state.copyWith(
    channel: state.channel == channel ? null : channel,
  );

  void setSort(PostingSort sort) => state = state.copyWith(sort: sort);
}
