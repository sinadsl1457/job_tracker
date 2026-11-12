import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';
import 'package:job_tracker/features/postings/presentation/postings_filter.dart';

import '../../helpers/fake_posting_repository.dart';

void main() {
  final today = DateTime(2026, 11, 12);

  group('applyPostingsFilter', () {
    final all = [
      posting(
        'a',
        channel: JobChannel.wanted,
        stage: ApplicationStage.applied,
        deadline: DateTime(2026, 11, 20),
      ),
      posting(
        'b',
        channel: JobChannel.saramin,
        deadline: DateTime(2026, 11, 13),
      ),
      posting(
        'c',
        channel: JobChannel.wanted,
        createdAt: DateTime(2026, 11, 5),
      ),
      posting(
        'd',
        channel: JobChannel.jobkorea,
        deadline: DateTime(2026, 11, 10),
      ),
      posting(
        'e',
        channel: JobChannel.wanted,
        deadline: DateTime(2026, 11, 12),
      ),
      posting('f', deadline: DateTime(2026, 11, 1)),
      posting('g', createdAt: DateTime(2026, 11, 8)),
    ];

    List<String> ids(PostingsFilter filter) => applyPostingsFilter(
      all,
      filter,
      today: today,
    ).map((p) => p.id).toList();

    test('마감 임박순: 남은 마감(가까운 순) → 마감일 없음(최근 등록순) → 지난 마감(최근에 지난 순)', () {
      expect(ids(const PostingsFilter()), ['e', 'b', 'a', 'g', 'c', 'd', 'f']);
    });

    test('채널과 단계를 함께 거른다', () {
      expect(ids(const PostingsFilter(channel: JobChannel.wanted)), [
        'e',
        'a',
        'c',
      ]);
      expect(
        ids(
          const PostingsFilter(
            channel: JobChannel.wanted,
            stage: ApplicationStage.applied,
          ),
        ),
        ['a'],
      );
    });

    test('최근 등록순·최근 변경순', () {
      final recent = [
        posting(
          'old',
          createdAt: DateTime(2026, 1, 1),
          stageChangedAt: DateTime(2026, 11, 11),
        ),
        posting(
          'new',
          createdAt: DateTime(2026, 11, 1),
          stageChangedAt: DateTime(2026, 11, 2),
        ),
      ];
      List<String> sorted(PostingSort sort) => applyPostingsFilter(
        recent,
        PostingsFilter(sort: sort),
        today: today,
      ).map((p) => p.id).toList();

      expect(sorted(PostingSort.recentlyCreated), ['new', 'old']);
      expect(sorted(PostingSort.recentlyChanged), ['old', 'new']);
    });
  });

  group('deadlineLabel', () {
    test('오늘은 D-day, 내일은 D-1, 지났으면 마감, 없으면 null', () {
      expect(deadlineLabel(DateTime(2026, 11, 12), today), 'D-day');
      expect(deadlineLabel(DateTime(2026, 11, 13), today), 'D-1');
      expect(deadlineLabel(DateTime(2026, 12, 12), today), 'D-30');
      expect(deadlineLabel(DateTime(2026, 11, 11), today), '마감');
      expect(deadlineLabel(null, today), isNull);
    });

    test('오늘 시각이 밤이어도 날짜로만 센다', () {
      expect(
        deadlineLabel(DateTime(2026, 11, 13), DateTime(2026, 11, 12, 23, 59)),
        'D-1',
      );
    });
  });
}
