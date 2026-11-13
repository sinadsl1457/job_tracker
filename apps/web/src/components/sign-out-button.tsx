// [Next] 누르는 버튼이라 브라우저에서 돌아야 한다 → 클라이언트 컴포넌트
"use client";
// 로그아웃 버튼. Flutter 목록 화면 앱바의 로그아웃 아이콘.
// 여러 화면이 같이 쓰는 부품이라 src/components/에 둔다(주소가 없는 화면 조각).

import { useRouter } from "next/navigation"; // [Next]

import { createClient } from "@/lib/supabase/client"; // [Supabase] 브라우저용

// [React] 컴포넌트
export function SignOutButton() {
  const router = useRouter(); // [Next]

  async function signOut() {
    // [Supabase] 로그아웃 = 쿠키의 출입증을 지운다
    await createClient().auth.signOut();
    router.replace("/login"); // [Next] 로그인 화면으로
    router.refresh(); // [Next] 서버에 화면 다시 요청(출입증 없는 상태로)
  }

  return (
    // [JSX] <button onClick={함수}> = TextButton(onPressed: signOut)
    // [Tailwind] underline = 밑줄
    <button onClick={signOut} className="text-sm text-zinc-600 underline">
      로그아웃
    </button>
  );
}
