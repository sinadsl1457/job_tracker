// 목록 필터·정렬·D-day 계산(순수 함수). 앱의 postings_filter.dart와 같은 규칙.
// 화면·React와 상관없는 순수 TypeScript라 단위 테스트(filter.test.ts)로 확인한다.

import type { Channel, Posting, Stage } from "./types";

// [TS] 세 글자 중 하나만 허용하는 타입 (Dart enum PostingSort)
export type PostingSort = "deadlineSoon" | "recentlyChanged" | "recentlyCreated";

export const SORT_LABEL: Record<PostingSort, string> = {
  deadlineSoon: "마감 임박순",
  recentlyChanged: "최근 변경순",
  recentlyCreated: "최근 등록순",
};

// [TS] 물음표(stage?) = 없어도 되는 칸. Dart의 ApplicationStage? stage
export type PostingsFilter = {
  stage?: Stage;
  channel?: Channel;
  sort: PostingSort;
};

// 날짜만 비교한다. "2026-11-13" 같은 글자를 UTC 자정 숫자로 바꿔 빼서 시각·시간대가 끼지 않게 한다.
function dayNumber(isoDate: string): number {
  // [TS] split("-").map(Number) = "2026-11-13" → [2026, 11, 13]
  const [y, m, d] = isoDate.split("-").map(Number);
  // [웹] Date.UTC = 그 날짜의 UTC 자정을 밀리초 숫자로. (JS의 Date는 Dart의 DateTime)
  return Date.UTC(y, m - 1, d) / 86_400_000; // 월은 0부터 센다(1월 = 0)
}

/** 오늘 날짜를 "YYYY-MM-DD"로. 사용자 기기의 현지 날짜 기준. */
export function todayIso(now: Date = new Date()): string {
  // [TS] padStart(2, "0") = 두 자리로 앞을 0으로 채우기. Dart의 padLeft(2, '0')
  const mm = String(now.getMonth() + 1).padStart(2, "0");
  const dd = String(now.getDate()).padStart(2, "0");
  return `${now.getFullYear()}-${mm}-${dd}`;
}

/** 마감까지 남은 날짜 수. 오늘 마감이면 0, 지났으면 음수, 마감일이 없으면 null. */
export function daysUntil(deadline: string | null, today: string): number | null {
  if (deadline == null) return null;
  return dayNumber(deadline) - dayNumber(today);
}

export function deadlineLabel(deadline: string | null, today: string): string | null {
  const days = daysUntil(deadline, today);
  if (days == null) return null;
  if (days < 0) return "마감";
  if (days === 0) return "D-day";
  return `D-${days}`;
}

export function applyPostingsFilter(
  postings: Posting[], // [TS] Posting[] = Dart의 List<Posting>
  filter: PostingsFilter,
  today: string,
): Posting[] {
  // [TS] filter(...) = Dart의 where(...).toList()
  const result = postings
    .filter((p) => filter.stage == null || p.stage === filter.stage)
    .filter((p) => filter.channel == null || p.channel === filter.channel);

  // ISO 시각 글자는 사전순 = 시간순이라 글자 비교로 최신순 정렬이 된다.
  // [TS] localeCompare = 글자 비교(compareTo). b부터 비교하면 내림차순.
  const newestFirst = (a: string, b: string) => b.localeCompare(a);

  switch (filter.sort) {
    case "recentlyCreated":
      // [TS] sort((a, b) => ...) = Dart의 sort((a, b) => ...). 원본을 바꾸므로 filter 결과(새 배열)에만 쓴다.
      return result.sort((a, b) => newestFirst(a.created_at, b.created_at));
    case "recentlyChanged":
      return result.sort((a, b) => newestFirst(a.stage_changed_at, b.stage_changed_at));
    case "deadlineSoon": {
      // 남은 마감(가까운 순) → 마감일 없음(최근 등록순) → 지난 마감(최근에 지난 순)
      const group = (p: Posting) => {
        const days = daysUntil(p.deadline, today);
        if (days == null) return 1;
        return days >= 0 ? 0 : 2;
      };
      return result.sort((a, b) => {
        const byGroup = group(a) - group(b);
        if (byGroup !== 0) return byGroup;
        if (group(a) === 0) return a.deadline!.localeCompare(b.deadline!);
        if (group(a) === 2) return newestFirst(a.deadline!, b.deadline!);
        return newestFirst(a.created_at, b.created_at);
      });
    }
  }
}
