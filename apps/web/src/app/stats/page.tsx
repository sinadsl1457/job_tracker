// /stats 화면 = 대시보드.
// [Next] 서버 컴포넌트로 만든다: 우리 웹 서버가 Supabase에서 데이터를 받아 통계를 계산하고,
//        숫자가 채워진 화면을 브라우저로 보낸다. (목록 화면은 브라우저에서 TanStack Query로 불러옴 — 비교해 볼 것)

// [Next] connection = "여기부터는 요청이 왔을 때 만든다"는 표시
import { connection } from "next/server";
import { Suspense } from "react"; // [React]

import { CHANNEL_LABEL, type Channel, type StageEvent } from "@/lib/postings/types";
import {
  computeFunnel,
  computeFunnelByChannel,
  type ChannelFunnel,
  type Funnel,
  localDate,
  weeklyApplied,
} from "@/lib/stats/funnel";
import { createClient } from "@/lib/supabase/server"; // [Supabase] 서버용 (쿠키의 출입증 사용)

import { AppHeader } from "../app-header";

import { WeeklyChart } from "./weekly-chart";

// 서버(Vercel)는 UTC로 돌아서, "오늘"과 "몇째 주"를 한국 날짜로 정하려면 시간대를 꼭 정해 준다.
const TIME_ZONE = "Asia/Seoul";

export default function StatsPage() {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 p-6">
      <AppHeader current="stats" />
      {/* [React] [Next] 쿠키를 읽고 데이터를 기다리는 부분은 Suspense 안에. 그동안 fallback이 보인다. */}
      <Suspense fallback={<p className="text-zinc-500">통계를 계산하는 중…</p>}>
        <Dashboard />
      </Suspense>
    </main>
  );
}

// [React] [Next] async 서버 컴포넌트: 그리기 전에 await로 데이터를 받는다.
async function Dashboard() {
  // [Next] 이 Next.js는 화면 틀을 미리(빌드 때) 만들어 두는데, 그때 "지금 시각"을 읽으면 에러를 낸다
  //        (미리 만든 시각이 굳어 버리니까). 아래에서 오늘 날짜를 쓰므로 요청 때 만들라고 표시한다.
  await connection();
  const supabase = await createClient();
  // [TS] Promise.all([...]) = 두 요청을 동시에 보내고 둘 다 끝날 때까지 기다리기. Dart의 Future.wait / (a, b).wait
  const [postingsRes, eventsRes] = await Promise.all([
    supabase.from("job_postings").select("id, channel").returns<{ id: string; channel: Channel }[]>(),
    supabase
      .from("application_events")
      .select("*")
      .order("changed_at", { ascending: true })
      .returns<StageEvent[]>(),
  ]);

  // [TS] 결과는 { data: 값, error: null } 또는 { data: null, error: 에러 } 둘 중 하나.
  //      둘의 error를 각각 검사해야 아래에서 "data는 확실히 있다"고 TypeScript가 알아챈다(타입 좁히기).
  //      Dart의 if (x == null) return; 뒤에서 x가 non-null로 바뀌는 것과 같다.
  if (postingsRes.error || eventsRes.error) {
    const message = (postingsRes.error ?? eventsRes.error)?.message;
    return (
      <p className="text-red-700">
        통계를 불러오지 못했습니다. 새로고침해 주세요. ({message})
      </p>
    );
  }

  const events = eventsRes.data;
  const funnel = computeFunnel(events);
  const byChannel = computeFunnelByChannel(postingsRes.data, events);
  const today = localDate(new Date().toISOString(), TIME_ZONE);
  const weeks = weeklyApplied(events, today, TIME_ZONE, 8);

  return (
    <div className="flex flex-col gap-8">
      <StatTiles funnel={funnel} />
      {/* 차트(마우스 반응)는 브라우저에서 돌아야 해서 클라이언트 컴포넌트. 계산한 숫자만 넘긴다. */}
      <WeeklyChart weeks={weeks} />
      <ChannelTable rows={byChannel} />
    </div>
  );
}

// ---- 숫자 타일 4개 (숫자 하나짜리라 차트가 아니라 타일로 보여 준다) ----

function percent(rate: number | null): string {
  return rate == null ? "-" : `${Math.round(rate * 100)}%`;
}

function StatTiles({ funnel: f }: { funnel: Funnel }) {
  // [TS] 객체 배열로 타일 정의를 적고 map으로 그린다
  const tiles = [
    { label: "지원", value: `${f.applied}건`, note: "지원 이상까지 간 공고" },
    { label: "열람률", value: percent(f.viewRate), note: `지원 ${f.applied}건 중 ${f.viewed}건 열람` },
    {
      label: "서류 통과율",
      value: percent(f.docPassRate),
      note: `지원 ${f.applied}건 중 ${f.docPassed}건 통과`,
    },
    {
      label: "면접 전환율",
      value: percent(f.interviewRate),
      note: `서류 통과 ${f.docPassed}건 중 ${f.interviewed}건 면접`,
    },
  ];
  return (
    <section aria-label="요약">
      {/* [Tailwind] grid grid-cols-2 sm:grid-cols-4 = 좁으면 2칸, 넓으면(640px 이상) 4칸 (GridView) */}
      <dl className="grid grid-cols-2 gap-3 sm:grid-cols-4">
        {tiles.map((t) => (
          <div key={t.label} className="rounded-lg border border-zinc-200 p-4">
            {/* [웹] <dl><dt><dd> = 이름-값 목록을 뜻하는 HTML 태그 */}
            <dt className="text-sm text-zinc-600">{t.label}</dt>
            <dd className="mt-1 text-3xl font-semibold">{t.value}</dd>
            <dd className="mt-1 text-xs text-zinc-500">{t.note}</dd>
          </div>
        ))}
      </dl>
    </section>
  );
}

// ---- 채널별 표 (지원 수는 가로 막대로 비교, 비율은 숫자로) ----

function ChannelTable({ rows }: { rows: ChannelFunnel[] }) {
  // [TS] Math.max(...배열) = 가장 큰 값. 1 이상으로 둬서 0으로 나누지 않게.
  const maxApplied = Math.max(1, ...rows.map((r) => r.applied));
  return (
    <section aria-labelledby="channel-title" className="flex flex-col gap-3">
      <h2 id="channel-title" className="text-lg font-semibold">
        채널별
      </h2>
      {/* [Tailwind] overflow-x-auto = 화면이 좁으면 표만 옆으로 밀어서 본다 */}
      <div className="overflow-x-auto">
        <table className="w-full min-w-[520px] text-sm">
          <thead className="text-left text-zinc-600">
            <tr className="border-b border-zinc-200">
              <th className="py-2 font-medium">채널</th>
              <th className="py-2 font-medium">지원</th>
              <th className="py-2 text-right font-medium">열람률</th>
              <th className="py-2 text-right font-medium">서류 통과율</th>
              <th className="py-2 text-right font-medium">면접 전환율</th>
            </tr>
          </thead>
          {/* [Tailwind] tabular-nums = 숫자 폭을 같게 해서 세로로 줄이 맞게 */}
          <tbody className="tabular-nums">
            {rows.map((r) => (
              <tr key={r.channel} className="border-b border-zinc-100">
                <td className="py-2">{CHANNEL_LABEL[r.channel]}</td>
                <td className="py-2">
                  <div className="flex items-center gap-2">
                    {/* 가는 막대: 가장 많은 채널을 꽉 찬 길이로 두고 비율대로 */}
                    <div className="h-2 w-32 rounded-full bg-zinc-100">
                      <div
                        className="h-2 rounded-full bg-[var(--viz-series-1)]"
                        // [JSX] style={{ ... }} = 계산한 값을 스타일로 직접 넣기 (Tailwind로는 숫자를 계산할 수 없어서)
                        style={{ width: `${(r.applied / maxApplied) * 100}%` }}
                      />
                    </div>
                    <span>{r.applied}건</span>
                  </div>
                </td>
                <td className="py-2 text-right">{percent(r.viewRate)}</td>
                <td className="py-2 text-right">{percent(r.docPassRate)}</td>
                <td className="py-2 text-right">{percent(r.interviewRate)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <p className="text-xs text-zinc-500">
        공고마다 한 번이라도 도달한 가장 먼 단계로 셉니다. 단계를 되돌려도 숫자가 늘지 않고, 불합격·보류가 된
        공고도 그전까지 간 단계로 셉니다. 비율의 분모가 0이면 &quot;-&quot;로 표시합니다.
      </p>
    </section>
  );
}
