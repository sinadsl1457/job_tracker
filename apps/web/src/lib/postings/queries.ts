// 공고 불러오기(TanStack Query). 앱의 posting_repository.dart + posting_providers.dart 자리.
// 브라우저에서 Supabase에 직접 묻는다. 내 데이터만 오는 건 RLS가 보장하므로 user_id 조건을 붙이지 않는다.

// [React] TanStack Query의 useQuery = 데이터 불러오기 + 캐시 + 다시 불러오기를 해 주는 훅.
//         Riverpod의 FutureProvider + ref.watch와 거의 같다.
import { useQuery } from "@tanstack/react-query";

import { createClient } from "@/lib/supabase/client"; // [Supabase] 브라우저용

import type { Posting } from "./types";

/** 연결 실패와 서버 오류를 나눠서 다른 문구를 보여 주기 위한 에러. (앱의 NetworkFailure / ServerFailure) */
// [TS] class X extends Error = Dart의 class X implements Exception
export class LoadError extends Error {
  // [TS] constructor(readonly kind: ...) = 생성자 인자를 바로 읽기 전용 필드로. Dart의 const LoadError(this.kind)
  constructor(
    readonly kind: "network" | "server",
    detail: string,
  ) {
    super(detail);
  }

  get userMessage(): string {
    return this.kind === "network"
      ? "서버에 연결하지 못했습니다. 네트워크를 확인해 주세요."
      : `서버 오류가 발생했습니다. (${this.message})`;
  }
}

// [TS] async function ...(): Promise<Posting[]> = Dart의 Future<List<Posting>> fetchPostings() async
export async function fetchPostings(): Promise<Posting[]> {
  const supabase = createClient();
  // [Supabase] from(테이블).select() = 앱의 _db.from('job_postings').select()
  //            order(...)는 ascending을 꼭 적는다(기본이 내림차순인 함정, AI_LOG 참고).
  // [TS] .returns<Posting[]>() = "돌아오는 줄은 Posting 모양"이라고 타입을 알려 준다.
  const { data, error } = await supabase
    .from("job_postings")
    .select("*")
    .order("created_at", { ascending: false })
    .returns<Posting[]>();

  if (error) {
    // supabase-js는 연결 실패를 코드 없는 에러("TypeError: Failed to fetch")로 준다.
    const isNetwork = !error.code && /fetch|network/i.test(error.message);
    throw new LoadError(isNetwork ? "network" : "server", error.message);
  }
  return data;
}

// [React] 커스텀 훅 = use로 시작하는 함수. 화면에서 usePostings() 한 줄로 쓴다.
//         Flutter의 ref.watch(postingsProvider) 자리.
export function usePostings() {
  return useQuery({
    // queryKey = 캐시 이름표. 같은 이름표면 같은 데이터를 공유하고, 이 이름표로 다시 불러오기(invalidate)를 한다.
    //            Riverpod의 provider 이름과 같은 역할.
    queryKey: ["postings"],
    queryFn: fetchPostings,
  });
}
