// 필터·정렬·D-day 단위 테스트. 앱의 postings_filter_test.dart와 같은 경우를 확인한다.
// 실행: npm test
// [TS] vitest = 테스트 도구. describe = group, it = test, expect(...).toEqual(...) = expect(..., ...)
import { describe, expect, it } from "vitest";

import { applyPostingsFilter, deadlineLabel, todayIso } from "./filter";
import type { Posting } from "./types";

// 테스트용 공고 만들기. 필요한 칸만 바꿔 쓴다.
// [TS] Partial<Posting> = Posting의 모든 칸이 선택(?)인 타입. 일부만 넘길 수 있다.
// [TS] ...over = 객체 펼치기. 기본값 위에 넘긴 칸을 덮어쓴다. Dart의 copyWith와 비슷하다.
function posting(id: string, over: Partial<Posting> = {}): Posting {
  return {
    id,
    company: `회사${id}`,
    position: `포지션${id}`,
    url: null,
    channel: "other",
    deadline: null,
    location: null,
    employment_type: null,
    memo: null,
    stage: "interested",
    stage_changed_at: "2026-11-01T00:00:00+00:00",
    created_at: "2026-11-01T00:00:00+00:00",
    updated_at: "2026-11-01T00:00:00+00:00",
    ...over,
  };
}

const today = "2026-11-12";

describe("applyPostingsFilter", () => {
  const all = [
    posting("a", { channel: "wanted", stage: "applied", deadline: "2026-11-20" }),
    posting("b", { channel: "saramin", deadline: "2026-11-13" }),
    posting("c", { channel: "wanted", created_at: "2026-11-05T00:00:00+00:00" }),
    posting("d", { channel: "jobkorea", deadline: "2026-11-10" }),
    posting("e", { channel: "wanted", deadline: "2026-11-12" }),
    posting("f", { deadline: "2026-11-01" }),
    posting("g", { created_at: "2026-11-08T00:00:00+00:00" }),
  ];
  const ids = (filter: Parameters<typeof applyPostingsFilter>[1]) =>
    applyPostingsFilter(all, filter, today).map((p) => p.id);

  it("마감 임박순: 남은 마감 → 마감일 없음(최근 등록순) → 지난 마감(최근에 지난 순)", () => {
    expect(ids({ sort: "deadlineSoon" })).toEqual(["e", "b", "a", "g", "c", "d", "f"]);
  });

  it("채널과 단계를 함께 거른다", () => {
    expect(ids({ sort: "deadlineSoon", channel: "wanted" })).toEqual(["e", "a", "c"]);
    expect(ids({ sort: "deadlineSoon", channel: "wanted", stage: "applied" })).toEqual(["a"]);
  });

  it("최근 등록순·최근 변경순", () => {
    const recent = [
      posting("old", {
        created_at: "2026-01-01T00:00:00+00:00",
        stage_changed_at: "2026-11-11T00:00:00+00:00",
      }),
      posting("new", {
        created_at: "2026-11-01T00:00:00+00:00",
        stage_changed_at: "2026-11-02T00:00:00+00:00",
      }),
    ];
    const sorted = (sort: "recentlyCreated" | "recentlyChanged") =>
      applyPostingsFilter(recent, { sort }, today).map((p) => p.id);
    expect(sorted("recentlyCreated")).toEqual(["new", "old"]);
    expect(sorted("recentlyChanged")).toEqual(["old", "new"]);
  });
});

describe("deadlineLabel", () => {
  it("오늘은 D-day, 내일은 D-1, 지났으면 마감, 없으면 null", () => {
    expect(deadlineLabel("2026-11-12", today)).toBe("D-day");
    expect(deadlineLabel("2026-11-13", today)).toBe("D-1");
    expect(deadlineLabel("2026-12-12", today)).toBe("D-30");
    expect(deadlineLabel("2026-11-11", today)).toBe("마감");
    expect(deadlineLabel(null, today)).toBeNull();
  });

  it("오늘 날짜는 밤늦은 시각이어도 그날로 센다", () => {
    expect(todayIso(new Date(2026, 10, 12, 23, 59))).toBe("2026-11-12");
  });
});
