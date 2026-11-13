// 로그인 뒤 화면들의 위쪽 메뉴(목록 / 대시보드 / 로그아웃). Flutter의 AppBar + 탭 자리.
// 여러 화면(목록·대시보드)이 같이 쓰는 부품이라 src/components/에 둔다.
// [Next] "use client"가 없으니 서버 컴포넌트. 누르는 로그아웃 버튼만 클라이언트 컴포넌트다.

// [Next] Link = 화면 이동 링크. 누르면 페이지 전체를 새로 받지 않고 바뀐 부분만 바꾼다. Flutter의 context.go
import Link from "next/link";

import { SignOutButton } from "./sign-out-button";

// [TS] { current }: { current: "postings" | "stats" } = 인자 객체의 모양을 그 자리에서 적은 것
export function AppHeader({ current }: { current: "postings" | "stats" }) {
  // [TS] 화살표 함수로 만든 작은 도우미. 지금 화면이면 진하게.
  const tab = (active: boolean) =>
    active ? "font-semibold text-indigo-700" : "text-zinc-600";

  return (
    // [JSX] <header>, <nav> = 위쪽 영역, 메뉴 묶음
    // [Tailwind] border-b = 아래 테두리, pb-3 = 아래 여백 12px
    <header className="flex items-center justify-between border-b border-zinc-200 pb-3">
      <nav className="flex items-center gap-4">
        <span className="text-xl font-semibold">지원 관리</span>
        {/* [Next] <Link href="주소"> */}
        <Link href="/postings" className={tab(current === "postings")}>
          목록
        </Link>
        <Link href="/stats" className={tab(current === "stats")}>
          대시보드
        </Link>
      </nav>
      <SignOutButton />
    </header>
  );
}
