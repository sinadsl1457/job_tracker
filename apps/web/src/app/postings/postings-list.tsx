// [Next] 필터 클릭·다시 불러오기가 있어서 브라우저에서 도는 클라이언트 컴포넌트
"use client";
// 공고 목록 + 필터. 앱의 postings_screen.dart(_PostingsList, _FilterBar, _PostingTile) 자리.

import { useState } from "react"; // [React]

import {
  applyPostingsFilter,
  daysUntil,
  deadlineLabel,
  type PostingSort,
  type PostingsFilter,
  SORT_LABEL,
  todayIso,
} from "@/lib/postings/filter";
import { LoadError, usePostings } from "@/lib/postings/queries";
import {
  CHANNEL_LABEL,
  CHANNELS,
  type Posting,
  STAGE_LABEL,
  STAGES,
  type Stage,
} from "@/lib/postings/types";

export function PostingsList() {
  // [React] TanStack Query 훅. Riverpod의 final postings = ref.watch(postingsProvider);
  //         isPending(불러오는 중) / isError(실패) / data(성공) = AsyncValue의 loading / error / data
  //         dataUpdatedAt = 마지막으로 성공해서 받아 온 시각(밀리초 숫자)
  const { data, error, isPending, isError, refetch, isFetching, dataUpdatedAt } =
    usePostings();
  // [React] 필터 상태. 앱의 PostingsFilterNotifier 자리(이 화면에서만 쓰니 useState로 충분)
  const [filter, setFilter] = useState<PostingsFilter>({ sort: "deadlineSoon" });

  // [JSX] 조건에 따라 다른 화면 돌려주기 = asyncValue.when(loading:, error:, data:)
  if (isPending) return <p className="text-zinc-500">불러오는 중…</p>;

  const errorMessage = isError
    ? error instanceof LoadError
      ? error.userMessage
      : "알 수 없는 오류가 발생했습니다."
    : null;

  // 처음부터 못 불러왔으면(보여 줄 목록이 없으면) 에러 화면.
  // 이미 목록이 있는데 새로 고침만 실패했으면 목록은 그대로 두고 아래에서 안내만 한다.
  if (data === undefined) {
    return (
      <div className="flex flex-col items-start gap-2">
        <p>{errorMessage}</p>
        {/* [React] refetch = 다시 불러오기. Riverpod의 ref.invalidate */}
        <button
          onClick={() => refetch()}
          className="rounded-full bg-zinc-200 px-4 py-1.5 text-sm"
        >
          다시 시도
        </button>
      </div>
    );
  }

  const today = todayIso();
  const visible = applyPostingsFilter(data, filter, today);

  return (
    <div className="flex flex-col gap-3">
      <FilterBar
        filter={filter}
        onChange={setFilter}
        onRefresh={() => refetch()}
        refreshing={isFetching}
        updatedAt={dataUpdatedAt}
      />

      {errorMessage && (
        // [웹] role="alert" = 화면 읽기 프로그램이 바로 읽어 주는 알림
        <p role="alert" className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
          새로 고치지 못했습니다. {errorMessage} (아래는 마지막으로 받아 온 목록입니다)
        </p>
      )}

      {data.length === 0 ? (
        <p className="py-12 text-center text-zinc-500">
          아직 등록한 공고가 없습니다. 앱에서 공고를 추가해 보세요.
        </p>
      ) : visible.length === 0 ? (
        <p className="py-12 text-center text-zinc-500">조건에 맞는 공고가 없습니다.</p>
      ) : (
        // [JSX] <ul> = 목록(ListView), <li> = 한 줄(ListTile)
        <ul className="divide-y divide-zinc-200">
          {/* [JSX] 배열.map(...)으로 줄 여러 개 만들기 = ListView.builder
              [React] key = 각 줄의 고유 이름표. 목록이 바뀔 때 React가 어느 줄인지 알아보는 데 쓴다(Flutter의 Key) */}
          {visible.map((p) => (
            <PostingRow key={p.id} posting={p} today={today} />
          ))}
        </ul>
      )}
    </div>
  );
}

// [TS] 인자 객체의 모양을 type으로 따로 적어 둔 것
type FilterBarProps = {
  filter: PostingsFilter;
  // [TS] (next: PostingsFilter) => void = 함수 타입. Dart의 void Function(PostingsFilter next)
  onChange: (next: PostingsFilter) => void;
  onRefresh: () => void;
  refreshing: boolean;
  updatedAt: number;
};

function FilterBar({ filter, onChange, onRefresh, refreshing, updatedAt }: FilterBarProps) {
  // [Tailwind] 공통 스타일을 변수로 빼서 재사용
  const selectClass = "rounded-md border border-zinc-300 px-2 py-1 text-sm";

  return (
    // [Tailwind] flex-wrap = 줄이 넘치면 다음 줄로 (Wrap 위젯)
    <div className="flex flex-wrap items-center gap-2">
      {/* [JSX] <select> + <option> = 드롭다운. DropdownButton */}
      <select
        aria-label="정렬"
        value={filter.sort}
        // [TS] ...filter = 기존 값 펼치고 sort만 바꾸기 = filter.copyWith(sort: ...)
        // [TS] as PostingSort = "이 글자는 PostingSort라고 내가 보장한다" (타입 단언)
        onChange={(e) => onChange({ ...filter, sort: e.target.value as PostingSort })}
        className={selectClass}
      >
        {/* [TS] Object.entries(객체) = [키, 값] 쌍 목록 */}
        {Object.entries(SORT_LABEL).map(([value, label]) => (
          <option key={value} value={value}>
            {label}
          </option>
        ))}
      </select>

      <select
        aria-label="단계"
        value={filter.stage ?? ""}
        onChange={(e) =>
          onChange({ ...filter, stage: (e.target.value || undefined) as Stage | undefined })
        }
        className={selectClass}
      >
        <option value="">전체 단계</option>
        {STAGES.map((s) => (
          <option key={s} value={s}>
            {STAGE_LABEL[s]}
          </option>
        ))}
      </select>

      {/* 채널 칩: 다시 누르면 해제 (앱의 FilterChip) */}
      {CHANNELS.map((c) => {
        const selected = filter.channel === c;
        return (
          <button
            key={c}
            // [웹] aria-pressed = 눌린 상태인지 화면 읽기 프로그램에 알려 줌(접근성)
            aria-pressed={selected}
            onClick={() => onChange({ ...filter, channel: selected ? undefined : c })}
            className={`rounded-full border px-3 py-1 text-sm ${
              selected
                ? "border-indigo-700 bg-indigo-50 text-indigo-700"
                : "border-zinc-300 text-zinc-700"
            }`}
          >
            {CHANNEL_LABEL[c]}
          </button>
        );
      })}

      {/* [Tailwind] ml-auto = 남은 공간을 왼쪽에 몰아 오른쪽 끝으로 (Spacer) */}
      <div className="ml-auto flex items-center gap-2 text-sm text-zinc-600">
        {/* 로컬에서는 몇 밀리초 만에 끝나서 "새로 고치는 중"이 안 보인다.
            마지막 업데이트 시각이 바뀌는 것으로 새로 받아 왔음을 알 수 있게 한다. */}
        <span>{formatTime(updatedAt)} 업데이트</span>
        <button
          onClick={onRefresh}
          disabled={refreshing}
          className="rounded-full border border-zinc-300 px-3 py-1 disabled:opacity-50"
        >
          {refreshing ? "새로 고치는 중…" : "새로 고침"}
        </button>
      </div>
    </div>
  );
}

function PostingRow({ posting: p, today }: { posting: Posting; today: string }) {
  const label = deadlineLabel(p.deadline, today);
  const days = daysUntil(p.deadline, today);
  // 아직 지원 전인데 마감이 하루 이내면 눈에 띄게 (앱과 같은 규칙)
  const urgent = p.stage === "interested" && days != null && days >= 0 && days <= 1;

  return (
    <li className="flex items-center justify-between gap-3 py-3">
      <div className="min-w-0">
        <p className="truncate font-medium">
          {p.company} · {p.position}
        </p>
        <p className="text-sm text-zinc-600">
          {CHANNEL_LABEL[p.channel]}
          {/* [JSX] {조건 && (...)} = 조건이 참일 때만 */}
          {label && (
            <>
              {/* [React] <>...</> = 이름 없는 묶음(Fragment). 감싸는 태그 없이 여러 개를 돌려줄 때 */}
              {" · "}
              <span className={urgent ? "font-bold text-red-600" : undefined}>{label}</span>
            </>
          )}
          {p.location && ` · ${p.location}`}
        </p>
      </div>
      <StageBadge stage={p.stage} />
    </li>
  );
}

function StageBadge({ stage }: { stage: Stage }) {
  // 앱의 StageChip과 같은 색 구분
  const color =
    stage === "final_passed"
      ? "bg-indigo-700 text-white"
      : stage === "rejected"
        ? "bg-zinc-200 text-zinc-600"
        : stage === "on_hold"
          ? "bg-amber-100 text-amber-800"
          : stage === "interested"
            ? "bg-zinc-100 text-zinc-800"
            : "bg-indigo-100 text-indigo-800";
  return (
    // [Tailwind] shrink-0 = 좁아져도 줄어들지 않음, whitespace-nowrap = 줄바꿈 안 함
    <span className={`shrink-0 whitespace-nowrap rounded-full px-2.5 py-1 text-xs ${color}`}>
      {STAGE_LABEL[stage]}
    </span>
  );
}

// 밀리초 숫자 → "15:20:13"
function formatTime(ms: number): string {
  // [웹] toLocaleTimeString = 사용자 지역 형식의 시각 글자. hour12: false = 24시간제
  return new Date(ms).toLocaleTimeString("ko-KR", { hour12: false });
}
