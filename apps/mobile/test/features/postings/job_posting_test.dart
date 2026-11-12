import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/postings/data/job_posting.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';

void main() {
  group('JobPosting.fromJson', () {
    test('Supabase 응답(snake_case, date, timestamptz, enum)을 읽는다', () {
      final posting = JobPosting.fromJson({
        'id': 'p1',
        'user_id': 'u1',
        'company': '토끼마켓',
        'position': 'Flutter 개발자',
        'url': null,
        'channel': 'wanted',
        'deadline': '2026-11-13',
        'location': '서울',
        'employment_type': 'full_time',
        'memo': null,
        'stage': 'doc_passed',
        'stage_changed_at': '2026-11-12T06:30:00.123456+00:00',
        'created_at': '2026-11-01T00:00:00+00:00',
        'updated_at': '2026-11-12T06:30:00+00:00',
      });

      expect(posting.channel, JobChannel.wanted);
      expect(posting.stage, ApplicationStage.docPassed);
      expect(posting.employmentType, EmploymentType.fullTime);
      expect(posting.deadline, DateTime(2026, 11, 13));
      expect(
        posting.stageChangedAt,
        DateTime.utc(2026, 11, 12, 6, 30, 0, 123, 456),
      );
    });

    test('마감일이 없으면 null', () {
      final json = {
        'id': 'p1',
        'company': 'a',
        'position': 'b',
        'channel': 'other',
        'deadline': null,
        'stage': 'interested',
        'stage_changed_at': '2026-11-12T00:00:00Z',
        'created_at': '2026-11-12T00:00:00Z',
        'updated_at': '2026-11-12T00:00:00Z',
      };
      expect(JobPosting.fromJson(json).deadline, isNull);
    });
  });

  group('PostingDraft.toRow', () {
    test('앞뒤 공백을 지우고 빈 칸은 null로 보낸다(지운 값도 저장되게)', () {
      final row = PostingDraft(
        company: ' 거북페이 ',
        position: '앱 개발',
        url: '  ',
        channel: JobChannel.saramin,
        deadline: DateTime(2026, 1, 5),
        memo: '',
      ).toRow();

      expect(row, {
        'company': '거북페이',
        'position': '앱 개발',
        'url': null,
        'channel': 'saramin',
        'deadline': '2026-01-05',
        'location': null,
        'employment_type': null,
        'memo': null,
      });
    });
  });

  test('StageEvent는 처음 등록(from 없음)도 읽는다', () {
    final event = StageEvent.fromJson({
      'id': 1,
      'posting_id': 'p1',
      'user_id': 'u1',
      'from_stage': null,
      'to_stage': 'interested',
      'changed_at': '2026-11-12T00:00:00+00:00',
    });
    expect(event.fromStage, isNull);
    expect(event.toStage, ApplicationStage.interested);
  });

  test('hasReached: 건너뛴 단계도 도달로 보고, 불합격·보류는 어디에도 도달하지 않는다', () {
    expect(
      ApplicationStage.docPassed.hasReached(ApplicationStage.viewed),
      isTrue,
    );
    expect(
      ApplicationStage.applied.hasReached(ApplicationStage.viewed),
      isFalse,
    );
    expect(
      ApplicationStage.rejected.hasReached(ApplicationStage.applied),
      isFalse,
    );
  });
}
