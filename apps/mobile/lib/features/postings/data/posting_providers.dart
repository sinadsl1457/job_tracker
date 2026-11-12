import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/supabase/supabase_providers.dart';
import 'job_posting.dart';
import 'posting_repository.dart';

part 'posting_providers.g.dart';

@Riverpod(keepAlive: true)
PostingRepository postingRepository(Ref ref) =>
    PostingRepository(ref.watch(supabaseClientProvider));

/// 내 공고 전체. 개인 데이터라 많아야 수백 개 → 한 번에 받아 앱에서 거르고 정렬한다.
@riverpod
Future<List<JobPosting>> postings(Ref ref) =>
    ref.watch(postingRepositoryProvider).fetchAll();

/// 내 모든 단계 이력(통계용).
@riverpod
Future<List<StageEvent>> allStageEvents(Ref ref) =>
    ref.watch(postingRepositoryProvider).fetchEvents();
