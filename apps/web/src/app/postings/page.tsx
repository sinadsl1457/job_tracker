// /postings 화면 = 공고 목록.
// [Next] src/app/postings/page.tsx → 주소 /postings
// [Next] 틀(머리 메뉴)은 서버 컴포넌트, 목록(PostingsList)은 브라우저에서 TanStack Query로 불러온다.
//        로그인 확인은 proxy.ts가 이미 했으므로 여기서는 쿠키를 읽지 않는다.

import { connection } from "next/server"; // [Next]
import { Suspense } from "react"; // [React]

import { AppHeader } from "@/components/app-header";

import { PostingsList } from "./postings-list";

export default function PostingsPage() {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-4 p-6">
      <AppHeader current="postings" />
      <Suspense fallback={<p className="text-zinc-500">불러오는 중…</p>}>
        <ListAtRequestTime />
      </Suspense>
    </main>
  );
}

// [Next] 목록은 오늘 날짜(D-day)와 TanStack Query 안의 "지금 시각"을 쓴다.
//        미리 만들어 두는 틀에서 지금 시각을 읽으면 에러라서, 이 부분은 요청이 왔을 때 만든다.
async function ListAtRequestTime() {
  await connection();
  return <PostingsList />;
}
