// [Next] 마우스를 올리면 값이 뜨는 차트라 브라우저에서 돌아야 한다 → 클라이언트 컴포넌트
"use client";
// 주간 지원 추이 막대 차트. 차트 라이브러리 없이 HTML 막대(div)로 그린다(무엇이 일어나는지 다 보이게).
// 숫자 계산은 서버(page.tsx)가 했고, 여기는 받은 숫자를 그리기만 한다.

import { useState } from "react"; // [React]

import type { WeekCount } from "@/lib/stats/funnel";

const CHART_HEIGHT = 160; // 막대가 그려지는 영역 높이(px)

// "2026-11-09" → "11/9"
function shortDate(date: string): string {
  const [, m, d] = date.split("-").map(Number);
  return `${m}/${d}`;
}

// 주 시작(월) → 그 주 일요일까지의 범위 글자
function weekRange(start: string): string {
  const [y, m, d] = start.split("-").map(Number);
  const end = new Date(Date.UTC(y, m - 1, d + 6)).toISOString().slice(0, 10);
  return `${shortDate(start)} – ${shortDate(end)}`;
}

export function WeeklyChart({ weeks }: { weeks: WeekCount[] }) {
  // [React] 지금 마우스가 올라간(또는 키보드로 고른) 막대 번호. 없으면 null
  const [active, setActive] = useState<number | null>(null);
  const max = Math.max(1, ...weeks.map((w) => w.count));
  const total = weeks.reduce((sum, w) => sum + w.count, 0); // [TS] reduce = Dart의 fold

  return (
    <section aria-labelledby="weekly-title" className="flex flex-col gap-3">
      <div>
        <h2 id="weekly-title" className="text-lg font-semibold">
          주간 지원 추이
        </h2>
        <p className="text-sm text-[var(--viz-text-secondary)]">
          최근 {weeks.length}주, 주마다 처음 지원한 공고 수 (합계 {total}건)
        </p>
      </div>

      {/* 차트 영역: 왼쪽 축 숫자 + 막대들 */}
      <div className="flex gap-2">
        {/* 세로 축: 0과 최댓값만 (작은 정수라 눈금이 많을 필요가 없다) */}
        <div
          className="flex flex-col justify-between text-right text-xs tabular-nums text-[var(--viz-text-muted)]"
          style={{ height: CHART_HEIGHT }}
          aria-hidden // [웹] 화면 읽기 프로그램은 건너뜀 (값은 각 막대와 표에 있음)
        >
          <span className="-translate-y-1/2">{max}</span>
          <span className="translate-y-1/2">0</span>
        </div>

        <div className="relative flex-1">
          {/* 최댓값 위치의 가는 눈금선 */}
          <div
            className="absolute inset-x-0 top-0 border-t border-[var(--viz-grid)]"
            aria-hidden
          />
          {/* 막대들: 바닥선 위에 아래에서 위로 자란다 */}
          {/* [웹] role="list" / "listitem" = 화면 읽기 프로그램에 "목록"이라고 알림 */}
          <div
            role="list"
            aria-label="주별 지원 수"
            className="flex items-end border-b border-[var(--viz-baseline)]"
            style={{ height: CHART_HEIGHT }}
          >
            {weeks.map((w, i) => {
              const isActive = active === i;
              return (
                // 막대 칸 전체가 마우스 대상(막대보다 넓게) → 작은 막대도 잘 잡힌다
                <div
                  key={w.weekStart}
                  role="listitem"
                  className="relative flex h-full flex-1 items-end justify-center"
                  // [React] onPointerEnter/Leave = 마우스가 들어오고 나갈 때. Flutter의 MouseRegion
                  onPointerEnter={() => setActive(i)}
                  onPointerLeave={() => setActive(null)}
                >
                  {/* [웹] tabIndex={0} = 키보드 Tab으로 이 막대에 올 수 있게. onFocus/onBlur = 키보드 선택 */}
                  <button
                    type="button"
                    aria-label={`${weekRange(w.weekStart)} 지원 ${w.count}건`}
                    onFocus={() => setActive(i)}
                    onBlur={() => setActive(null)}
                    className="flex h-full w-full items-end justify-center focus:outline-none"
                  >
                    {/* 막대: 24px 이하, 위쪽만 4px 둥글게, 0이면 그리지 않음 */}
                    {w.count > 0 && (
                      <span
                        className="block w-full max-w-6 rounded-t"
                        style={{
                          height: `${(w.count / max) * 100}%`,
                          background: isActive
                            ? "var(--viz-series-1-hover)"
                            : "var(--viz-series-1)",
                        }}
                      />
                    )}
                  </button>

                  {/* 말풍선: 값이 먼저(굵게), 기간은 다음 */}
                  {isActive && (
                    <div
                      role="tooltip"
                      className="pointer-events-none absolute bottom-full z-10 mb-2 whitespace-nowrap rounded-md border border-zinc-200 bg-white px-2.5 py-1.5 text-xs shadow-sm"
                    >
                      <p className="text-sm font-semibold">{w.count}건</p>
                      <p className="text-[var(--viz-text-secondary)]">{weekRange(w.weekStart)}</p>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
          {/* 가로 축: 주 시작 날짜 */}
          <div className="flex text-xs tabular-nums text-[var(--viz-text-muted)]" aria-hidden>
            {weeks.map((w) => (
              <span key={w.weekStart} className="flex-1 pt-1 text-center">
                {shortDate(w.weekStart)}
              </span>
            ))}
          </div>
        </div>
      </div>

      {/* 표로 보기: 마우스 없이도 모든 값을 볼 수 있게 */}
      {/* [웹] <details><summary> = 눌러서 펼치는 영역(ExpansionTile) */}
      <details className="text-sm">
        <summary className="cursor-pointer text-[var(--viz-text-secondary)]">표로 보기</summary>
        <table className="mt-2 w-full max-w-xs tabular-nums">
          <thead>
            <tr className="border-b border-zinc-200 text-left text-zinc-600">
              <th className="py-1 font-medium">주</th>
              <th className="py-1 text-right font-medium">지원</th>
            </tr>
          </thead>
          <tbody>
            {weeks.map((w) => (
              <tr key={w.weekStart} className="border-b border-zinc-100">
                <td className="py-1">{weekRange(w.weekStart)}</td>
                <td className="py-1 text-right">{w.count}건</td>
              </tr>
            ))}
          </tbody>
        </table>
      </details>
    </section>
  );
}
