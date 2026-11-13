// /login 화면.
// [Next] 파일 위치 규칙: src/app/login/page.tsx → 주소 /login. go_router에 경로를 등록하는 일을 폴더가 대신한다.
// [Next] 맨 위에 "use client"가 없으니 서버 컴포넌트(우리 웹 서버에서 만들어 보냄).
//        틀(제목)은 서버에서 만들고, 입력 부분(LoginForm)만 브라우저에서 돈다.

import { LoginForm } from "./login-form";

// [Next] export default function = 이 파일의 "대표" 화면. page.tsx는 반드시 이렇게 내보내야 Next.js가 화면으로 쓴다.
// [React] 함수 하나 = 화면 조각 하나(StatelessWidget)
export default function LoginPage() {
  return (
    // [JSX] <main> = 본문 영역 (Scaffold의 body)
    // [Tailwind] mx-auto max-w-sm = 가운데 정렬, 최대 너비 384px (ConstrainedBox + Center)
    //            flex-1 flex-col justify-center = Expanded + Column(mainAxisAlignment: center)
    <main className="mx-auto flex w-full max-w-sm flex-1 flex-col justify-center gap-8 px-6">
      {/* [JSX] <h1> = 가장 큰 제목 Text */}
      <h1 className="text-center text-3xl font-semibold">지원 관리</h1>
      {/* [React] 다른 파일의 컴포넌트를 위젯처럼 끼워 넣기 */}
      <LoginForm />
    </main>
  );
}
