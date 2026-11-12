import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/posting_detail/data/stage_change_rule.dart';
import 'package:job_tracker/features/postings/data/posting_enums.dart';

void main() {
  final now = DateTime(2026, 11, 12, 15, 30);

  group('stageChangeTime', () {
    test('오늘을 고르면 지금 시각', () {
      expect(stageChangeTime(DateTime(2026, 11, 12), now), now);
    });

    test('지난 날을 고르면 그날 23:59', () {
      expect(
        stageChangeTime(DateTime(2026, 11, 3), now),
        DateTime(2026, 11, 3, 23, 59),
      );
    });
  });

  group('checkStageChange', () {
    StageChangeError? check({
      ApplicationStage current = ApplicationStage.applied,
      ApplicationStage next = ApplicationStage.viewed,
      required DateTime at,
      DateTime? lastChangedAt,
    }) => checkStageChange(
      current: current,
      next: next,
      at: at,
      lastChangedAt: lastChangedAt ?? DateTime(2026, 11, 1, 9),
      now: now,
    );

    test('정상 변경은 통과', () {
      expect(check(at: now), isNull);
    });

    test('같은 단계로는 바꿀 수 없다', () {
      expect(
        check(next: ApplicationStage.applied, at: now),
        StageChangeError.sameStage,
      );
    });

    test('미래 시각은 거부', () {
      expect(
        check(at: now.add(const Duration(minutes: 1))),
        StageChangeError.future,
      );
    });

    test('이전 단계로 바뀐 시각보다 빠르면 거부, 같으면 통과', () {
      final last = DateTime(2026, 11, 5, 23, 59);
      expect(
        check(at: DateTime(2026, 11, 4, 23, 59), lastChangedAt: last),
        StageChangeError.beforeLastChange,
      );
      expect(check(at: last, lastChangedAt: last), isNull);
    });

    test('같은 지난 날에 두 번 바꿔도(둘 다 23:59) 거부되지 않는다', () {
      final first = stageChangeTime(DateTime(2026, 11, 5), now);
      final second = stageChangeTime(DateTime(2026, 11, 5), now);
      expect(check(at: second, lastChangedAt: first), isNull);
    });

    test('불합격·보류에서 진행 단계로 되돌리는 것도 허용(잘못 누른 것 고치기)', () {
      expect(
        check(
          current: ApplicationStage.rejected,
          next: ApplicationStage.interview1,
          at: now,
        ),
        isNull,
      );
    });
  });
}
