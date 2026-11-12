// 등록([postingId] 없음)·수정 화면. 처음 값을 불러오고 저장한다.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../postings/data/job_posting.dart';
import '../../postings/data/posting_providers.dart';

part 'posting_form_notifier.g.dart';

@riverpod
class PostingFormNotifier extends _$PostingFormNotifier {
  @override
  Future<PostingDraft> build(String? postingId) async {
    if (postingId == null) return const PostingDraft();
    final posting = await ref.watch(postingRepositoryProvider).fetch(postingId);
    return PostingDraft.fromPosting(posting);
  }

  /// 실패하면 AppFailure를 던진다. 화면이 받아서 알린다.
  Future<JobPosting> save(PostingDraft draft) async {
    final repository = ref.read(postingRepositoryProvider);
    final saved = postingId == null
        ? await repository.create(draft)
        : await repository.update(postingId!, draft);
    if (ref.mounted) ref.invalidate(postingsProvider);
    return saved;
  }
}
