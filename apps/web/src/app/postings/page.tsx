// /postings 화면(지금은 로그인 확인용 임시 화면, 다음 편에 공고 목록으로 바꾼다).
// [Next] src/app/postings/page.tsx → 주소 /postings
// [Next] "use client"가 없으니 서버 컴포넌트

// [React] Suspense = 기다리는 동안 대신 보여 줄 것을 정하는 React 기능. Riverpod의 .when(loading: ...)
import { Suspense } from "react";

// [Supabase] 서버용 클라이언트 (쿠키에서 출입증을 꺼내 씀)
import { createClient } from "@/lib/supabase/server";

// [TS] "../" = 한 폴더 위 (src/app/sign-out-button.tsx)
import { SignOutButton } from "../sign-out-button";

// [Next] page.tsx의 대표 화면
export default function PostingsPage() {
  return (
    // [Tailwind] p-6 = 사방 여백 24px
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-4 p-6">
      {/* [JSX] <header> = 위쪽 영역 (AppBar 자리)
          [Tailwind] flex items-center justify-between = Row(mainAxisAlignment: spaceBetween) */}
      <header className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">지원 관리</h1>
        {/* [React] 서버 컴포넌트 안에 클라이언트 컴포넌트를 끼울 수 있다. 버튼만 브라우저에서 돈다. */}
        <SignOutButton />
      </header>
      {/* [React] 쿠키(로그인 정보)를 읽는 부분은 Suspense 안에 둔다. 그동안 fallback이 보인다.
          [Next] 이 Next.js 버전은 쿠키를 읽는 부분을 Suspense 없이 쓰면 빌드 에러를 낸다. */}
      <Suspense fallback={<p className="text-zinc-500">불러오는 중…</p>}>
        <SignedInAs />
      </Suspense>
    </main>
  );
}

// [React] [Next] async 컴포넌트 = 서버 컴포넌트만 가능. 그리기 전에 await로 데이터를 기다릴 수 있다.
//               (클라이언트 컴포넌트는 async가 안 된다. Flutter build()가 async가 안 되는 것과 같다.)
async function SignedInAs() {
  const supabase = await createClient(); // [Supabase] 서버용
  // [Supabase] getClaims = 출입증 안의 내용(sub, email 등)을 확인해서 돌려준다
  const { data } = await supabase.auth.getClaims();
  // [JSX] {data?.claims.email} = TS 값을 화면 글자로 끼워 넣기. Text('${data?.claims.email}')
  return <p>{data?.claims.email} 로 로그인했습니다.</p>;
}
