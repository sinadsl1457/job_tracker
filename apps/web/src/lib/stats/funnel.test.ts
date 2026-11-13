// 대시보드 통계 단위 테스트. 앱의 funnel_stats_test.dart와 같은 경우 + 채널별·주간 추이.
import { describe, expect, it } from "vitest";

import type { Stage, StageEvent } from "@/lib/postings/types";

import {
  computeFunnel,
  computeFunnelByChannel,
  localDate,
  weekStart,
  weeklyApplied,
} from "./funnel";

let nextId = 1;
/** 공고 하나가 거친 단계들을 이력으로 만든다. dates를 주면 그 시각, 없으면 11/1부터 하루씩. */
function path(postingId: string, stages: Stage[], dates?: string[]): StageEvent[] {
  return stages.map((to, i) => ({
    id: nextId++,
    posting_id: postingId,
    from_stage: i === 0 ? null : stages[i - 1],
    to_stage: to,
    changed_at: dates?.[i] ?? `2026-11-${String(1 + i).padStart(2, "0")}T03:00:00+00:00`,
  }));
}

describe("computeFunnel", () => {
  it("이력이 없으면 모두 0, 비율은 null(0%와 구분)", () => {
    const f = computeFunnel([]);
    expect(f.applied).toBe(0);
    expect(f.viewRate).toBeNull();
    expect(f.interviewRate).toBeNull();
  });

  it("기본 계산: 지원 4 → 열람 3 → 서류 2 → 면접 1", () => {
    const f = computeFunnel([
      ...path("a", ["interested", "applied"]),
      ...path("b", ["interested", "applied", "viewed"]),
      ...path("c", ["interested", "applied", "viewed", "doc_passed"]),
      ...path("d", ["applied", "viewed", "doc_passed", "interview_1"]),
      ...path("e", ["interested"]),
    ]);
    expect([f.applied, f.viewed, f.docPassed, f.interviewed]).toEqual([4, 3, 2, 1]);
    expect(f.viewRate).toBe(0.75);
    expect(f.docPassRate).toBe(0.5);
    expect(f.interviewRate).toBe(0.5);
  });

  it("단계를 왔다 갔다 해도 공고 하나는 한 번만 센다", () => {
    const f = computeFunnel(path("a", ["interested", "applied", "viewed", "applied", "viewed"]));
    expect([f.applied, f.viewed]).toEqual([1, 1]);
  });

  it("열람 없이 서류합격으로 건너뛰어도 열람까지 도달한 것으로 센다", () => {
    const f = computeFunnel(path("a", ["applied", "doc_passed"]));
    expect([f.applied, f.viewed, f.docPassed]).toEqual([1, 1, 1]);
  });

  it("불합격·보류가 돼도 그전까지 도달한 단계로 센다", () => {
    const f = computeFunnel([
      ...path("a", ["applied", "viewed", "rejected"]),
      ...path("b", ["applied", "on_hold"]),
    ]);
    expect([f.applied, f.viewed, f.docPassed]).toEqual([2, 1, 0]);
  });
});

describe("computeFunnelByChannel", () => {
  it("공고의 채널별로 나눠 세고, 지원 수가 많은 순으로 준다", () => {
    const postings = [
      { id: "a", channel: "wanted" as const },
      { id: "b", channel: "wanted" as const },
      { id: "c", channel: "saramin" as const },
    ];
    const rows = computeFunnelByChannel(postings, [
      ...path("a", ["applied", "viewed"]),
      ...path("b", ["applied"]),
      ...path("c", ["applied", "viewed", "doc_passed"]),
    ]);
    expect(rows.map((r) => [r.channel, r.applied, r.viewed])).toEqual([
      ["wanted", 2, 1],
      ["saramin", 1, 1],
      ["jobkorea", 0, 0],
      ["other", 0, 0],
    ]);
    expect(rows[0].viewRate).toBe(0.5);
    expect(rows[2].viewRate).toBeNull();
  });
});

describe("weeklyApplied", () => {
  const tz = "Asia/Seoul";

  it("주는 월요일부터 시작한다", () => {
    expect(weekStart("2026-11-12")).toBe("2026-11-09"); // 목 → 그 주 월
    expect(weekStart("2026-11-09")).toBe("2026-11-09"); // 월 → 그대로
    expect(weekStart("2026-11-15")).toBe("2026-11-09"); // 일 → 그 주 월
  });

  it("UTC로는 전날이어도 한국 날짜로 센다", () => {
    // 11/8 23:30 UTC = 11/9 08:30 KST (월요일)
    expect(localDate("2026-11-08T23:30:00+00:00", tz)).toBe("2026-11-09");
  });

  it("공고마다 처음 지원 이상이 된 주에 한 번만 센다", () => {
    const events = [
      // a: 11/3 지원 → 11/10 열람 (지원은 11/3 주에 1번)
      ...path("a", ["interested", "applied", "viewed"], [
        "2026-11-01T03:00:00+00:00",
        "2026-11-03T03:00:00+00:00",
        "2026-11-10T03:00:00+00:00",
      ]),
      // b: 관심 → 서류합격으로 건너뜀(11/11) → 그날 지원한 것으로
      ...path("b", ["interested", "doc_passed"], [
        "2026-11-02T03:00:00+00:00",
        "2026-11-11T03:00:00+00:00",
      ]),
      // c: 관심만 → 안 셈
      ...path("c", ["interested"]),
      // d: 너무 오래전(범위 밖) → 안 셈
      ...path("d", ["applied"], ["2026-01-05T03:00:00+00:00"]),
    ];
    const weeks = weeklyApplied(events, "2026-11-12", tz, 3);
    expect(weeks).toEqual([
      { weekStart: "2026-10-26", count: 0 },
      { weekStart: "2026-11-02", count: 1 },
      { weekStart: "2026-11-09", count: 1 },
    ]);
  });
});
