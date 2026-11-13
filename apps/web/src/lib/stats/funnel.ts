// 대시보드 통계 계산(순수 함수). 앱의 funnel_stats.dart와 같은 정의를 쓴다.
// 공고마다 "한 번이라도 도달한 가장 먼 단계"로 센다 → 단계를 왔다 갔다 해도 부풀지 않고,
// 불합격·보류가 된 공고도 그전까지 도달한 단계로 센다.

import { type Channel, CHANNELS, STAGE_PROGRESS, type StageEvent } from "@/lib/postings/types";

// [TS] 통계 결과의 모양
export type Funnel = {
  applied: number; // 지원 이상에 도달한 공고 수
  viewed: number; // 열람 이상
  docPassed: number; // 서류합격 이상
  interviewed: number; // 1차면접 이상
  viewRate: number | null; // 분모가 0이면 null(0%와 구분)
  docPassRate: number | null;
  interviewRate: number | null;
};

const ratio = (part: number, whole: number) => (whole === 0 ? null : part / whole);

/** 공고 id → 그 공고가 도달한 가장 먼 진행 순서 */
function furthestByPosting(events: StageEvent[]): Map<string, number> {
  // [TS] Map<키, 값> = Dart의 Map. new Map() = {}
  const furthest = new Map<string, number>();
  for (const e of events) {
    const progress = STAGE_PROGRESS[e.to_stage];
    if (progress == null) continue; // 불합격·보류는 순서 밖
    const before = furthest.get(e.posting_id);
    if (before === undefined || progress > before) furthest.set(e.posting_id, progress);
  }
  return furthest;
}

function funnelFrom(progresses: number[]): Funnel {
  const reached = (p: number) => progresses.filter((x) => x >= p).length;
  const applied = reached(STAGE_PROGRESS.applied!);
  const viewed = reached(STAGE_PROGRESS.viewed!);
  const docPassed = reached(STAGE_PROGRESS.doc_passed!);
  const interviewed = reached(STAGE_PROGRESS.interview_1!);
  return {
    applied,
    viewed,
    docPassed,
    interviewed,
    viewRate: ratio(viewed, applied),
    docPassRate: ratio(docPassed, applied),
    interviewRate: ratio(interviewed, docPassed),
  };
}

export function computeFunnel(events: StageEvent[]): Funnel {
  // [TS] [...map.values()] = Map의 값들을 배열로. Dart의 map.values.toList()
  return funnelFrom([...furthestByPosting(events).values()]);
}

export type ChannelFunnel = { channel: Channel } & Funnel;

/** 채널별 통계. 공고의 채널은 postings에서 찾는다. 지원 수가 많은 순. */
export function computeFunnelByChannel(
  postings: { id: string; channel: Channel }[],
  events: StageEvent[],
): ChannelFunnel[] {
  const channelOf = new Map(postings.map((p) => [p.id, p.channel]));
  const furthest = furthestByPosting(events);
  return CHANNELS.map((channel) => {
    const progresses = [...furthest.entries()]
      .filter(([postingId]) => channelOf.get(postingId) === channel)
      .map(([, progress]) => progress);
    return { channel, ...funnelFrom(progresses) };
  }).sort((a, b) => b.applied - a.applied);
}

// ---- 주간 지원 추이 ----

/** ISO 시각 → 그 시간대의 날짜 "YYYY-MM-DD". 서버(Vercel)는 UTC라서 시간대를 꼭 정해 준다. */
export function localDate(iso: string, timeZone: string): string {
  // [웹] Intl.DateTimeFormat = 날짜를 지역 형식으로. "en-CA"는 YYYY-MM-DD 모양으로 나온다.
  return new Intl.DateTimeFormat("en-CA", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(iso));
}

function dayNumber(date: string): number {
  const [y, m, d] = date.split("-").map(Number);
  return Date.UTC(y, m - 1, d) / 86_400_000;
}

function fromDayNumber(n: number): string {
  return new Date(n * 86_400_000).toISOString().slice(0, 10);
}

/** 그 날짜가 속한 주의 월요일 */
export function weekStart(date: string): string {
  const n = dayNumber(date);
  // [웹] getUTCDay(): 일요일 0 ~ 토요일 6 → 월요일 기준으로 며칠 지났는지
  const sinceMonday = (new Date(n * 86_400_000).getUTCDay() + 6) % 7;
  return fromDayNumber(n - sinceMonday);
}

export type WeekCount = { weekStart: string; count: number };

/**
 * 최근 [weeks]주 동안 주마다 "처음 지원 이상이 된" 공고 수. 오래된 주 → 이번 주 순.
 * 관심에서 바로 서류합격으로 건너뛴 공고도 그날 지원한 것으로 센다.
 */
export function weeklyApplied(
  events: StageEvent[],
  today: string,
  timeZone: string,
  weeks = 8,
): WeekCount[] {
  const firstApplied = new Map<string, string>(); // 공고 id → 처음 지원 이상이 된 날짜
  const ordered = [...events].sort(
    (a, b) => a.changed_at.localeCompare(b.changed_at) || a.id - b.id,
  );
  for (const e of ordered) {
    const progress = STAGE_PROGRESS[e.to_stage];
    if (progress == null || progress < STAGE_PROGRESS.applied!) continue;
    if (!firstApplied.has(e.posting_id)) {
      firstApplied.set(e.posting_id, localDate(e.changed_at, timeZone));
    }
  }

  const thisWeek = dayNumber(weekStart(today));
  // [TS] Array.from({ length: n }, (_, i) => ...) = List.generate(n, (i) => ...)
  const result: WeekCount[] = Array.from({ length: weeks }, (_, i) => ({
    weekStart: fromDayNumber(thisWeek - (weeks - 1 - i) * 7),
    count: 0,
  }));
  const index = new Map(result.map((w, i) => [w.weekStart, i]));
  for (const date of firstApplied.values()) {
    const i = index.get(weekStart(date));
    if (i !== undefined) result[i].count += 1;
  }
  return result;
}
