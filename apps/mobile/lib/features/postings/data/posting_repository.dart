// 공고·단계 이력 읽기/쓰기. Supabase 쿼리는 이 클래스 안에만 둔다.
// 내 데이터만 오는 것은 RLS가 보장해서 user_id 조건을 붙이지 않는다.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/app_failure.dart';
import 'job_posting.dart';
import 'posting_enums.dart';

class PostingRepository {
  PostingRepository(this._db);

  final SupabaseClient _db;

  static const _postings = 'job_postings';
  static const _events = 'application_events';

  Future<List<JobPosting>> fetchAll() => _guard(() async {
    final rows = await _db
        .from(_postings)
        .select()
        .order('created_at', ascending: false);
    return rows.map(JobPosting.fromJson).toList();
  });

  Future<JobPosting> fetch(String id) => _guard(() async {
    final row = await _db.from(_postings).select().eq('id', id).single();
    return JobPosting.fromJson(row);
  });

  /// [postingId]가 없으면 내 모든 공고의 이력(통계용).
  Future<List<StageEvent>> fetchEvents({String? postingId}) => _guard(() async {
    var query = _db.from(_events).select();
    if (postingId != null) query = query.eq('posting_id', postingId);
    // postgrest-dart의 order()는 기본이 내림차순이라 오름차순을 꼭 적는다.
    final rows = await query
        .order('changed_at', ascending: true)
        .order('id', ascending: true);
    return rows.map(StageEvent.fromJson).toList();
  });

  Future<JobPosting> create(PostingDraft draft) => _guard(() async {
    final row = await _db
        .from(_postings)
        .insert(draft.toRow())
        .select()
        .single();
    return JobPosting.fromJson(row);
  });

  Future<JobPosting> update(String id, PostingDraft draft) => _guard(() async {
    final row = await _db
        .from(_postings)
        .update(draft.toRow())
        .eq('id', id)
        .select()
        .single();
    return JobPosting.fromJson(row);
  });

  Future<void> delete(String id) =>
      _guard(() => _db.from(_postings).delete().eq('id', id));

  /// 이력은 DB 트리거가 남긴다. [at]이 없으면 DB가 지금 시각을 쓴다.
  Future<JobPosting> changeStage(
    String id,
    ApplicationStage stage, {
    DateTime? at,
  }) => _guard(() async {
    final row = await _db
        .from(_postings)
        .update({
          'stage': stage.dbValue,
          if (at != null) 'stage_changed_at': at.toUtc().toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single();
    return JobPosting.fromJson(row);
  });

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      // 22023: 트리거가 거부한 날짜(미래, 이전 단계보다 빠름)
      if (e.code == '22023') throw const StageDateRejectedFailure();
      throw AppFailure.from(e);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}
