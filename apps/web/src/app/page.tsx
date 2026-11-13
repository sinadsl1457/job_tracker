// / 주소로 오면 목록으로 보낸다(로그인 안 했으면 proxy.ts가 먼저 /login으로 보냄).
// [Next] src/app/page.tsx → 주소 / (첫 화면)

// [Next] redirect = 서버에서 "이 주소로 다시 가라"고 보내기. go_router redirect의 return '/postings'
import { redirect } from "next/navigation";

// [Next] 대표 화면. 화면을 그리지 않고 바로 다른 주소로 보낸다.
export default function Home() {
  redirect("/postings");
}
