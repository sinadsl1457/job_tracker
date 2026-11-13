// /postings 화면 = 공고 목록.
// [Next] src/app/postings/page.tsx → 주소 /postings
// [Next] 틀(머리 메뉴)은 서버 컴포넌트, 목록(PostingsList)은 브라우저에서 TanStack Query로 불러온다.
//        로그인 확인은 proxy.ts가 이미 했으므로 여기서는 쿠키를 읽지 않는다.

import { AppHeader } from "../app-header";

import { PostingsList } from "./postings-list";

export default function PostingsPage() {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-4 p-6">
      <AppHeader current="postings" />
      <PostingsList />
    </main>
  );
}
