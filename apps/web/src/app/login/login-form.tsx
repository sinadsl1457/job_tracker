// [Next] "use client" = 이 파일은 브라우저에서 돈다(클라이언트 컴포넌트). 반드시 파일 맨 첫 줄.
//        입력칸·버튼처럼 사용자와 주고받는 부분이라 브라우저에서 돌아야 한다.
"use client";
// 로그인 입력 폼. Flutter로 치면 LoginScreen의 Form + LoginNotifier를 한 파일에 합친 것.

// [Next] useRouter = 코드로 화면을 이동시키는 Next.js 기능. Flutter의 context.go / GoRouter
import { useRouter } from "next/navigation";
// [React] useState = 상태 하나를 만드는 React 기능. Flutter StatefulWidget의 필드 + setState
// [React] FormEvent = 폼 제출 이벤트의 타입
import { type FormEvent, useState } from "react";

// [TS] @/ = src/ 폴더를 뜻하는 줄임말(tsconfig.json에 설정됨). Dart의 package:job_tracker/
import { authErrorMessage } from "@/lib/auth-errors";
import { createClient } from "@/lib/supabase/client";

// [TS] type Mode = "signIn" | "signUp" = 이 두 글자 중 하나만 허용하는 타입. Dart의 enum LoginMode와 같은 역할
type Mode = "signIn" | "signUp";

// [React] 화면 조각(컴포넌트) = 대문자로 시작하는 함수. Flutter의 위젯 클래스 하나.
//         함수 전체가 build 메서드라고 보면 된다. 상태가 바뀌면 이 함수가 다시 불려 화면을 다시 그린다.
export function LoginForm() {
  const router = useRouter(); // [Next]

  // [React] const [값, 바꾸는함수] = useState(처음값)
  //         값을 바꿀 땐 반드시 setMode(새값)처럼 바꾸는 함수를 쓴다 → 화면이 다시 그려진다(= setState)
  // [TS] useState<Mode>(...) = 이 상태의 타입은 Mode. Dart의 제네릭 <Mode>와 같다.
  const [mode, setMode] = useState<Mode>("signIn");
  const [email, setEmail] = useState(""); // [React]
  const [password, setPassword] = useState(""); // [React]
  const [submitting, setSubmitting] = useState(false); // [React]
  const [error, setError] = useState<string | null>(null); // [React] [TS] String?
  const [info, setInfo] = useState<string | null>(null); // [React]

  // [TS] === = 같은지 비교. JS는 == 가 이상하게 동작할 때가 있어서 === 를 쓴다. Dart의 == 와 같다고 보면 된다.
  const isSignUp = mode === "signUp";

  // 로그인/가입 버튼을 누르면 불리는 함수. Flutter의 _submit()
  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    // [웹] 폼을 제출하면 브라우저는 원래 페이지를 새로고침한다. 그걸 막는다.
    event.preventDefault();
    setSubmitting(true); // [React]
    setError(null);
    setInfo(null);

    const supabase = createClient(); // [Supabase] 브라우저용
    // [TS] 조건 ? A : B = Dart와 같은 삼항 연산자
    // [Supabase] signUp / signInWithPassword = 가입 / 로그인 요청. 성공하면 출입증을 쿠키에 저장한다.
    //            결과는 { data, error } 모양이라 예외(throw) 대신 error를 확인한다.
    const { data, error } = isSignUp
      ? await supabase.auth.signUp({ email: email.trim(), password })
      : await supabase.auth.signInWithPassword({ email: email.trim(), password });
    // [TS] { email: email.trim(), password } 에서 password만 쓴 건 { password: password }의 줄임

    if (error) {
      setError(authErrorMessage(error.code));
      setSubmitting(false);
      return;
    }
    if (!data.session) {
      // 클라우드 기본 설정: 가입 확인 메일을 눌러야 로그인된다
      setInfo("가입 확인 메일을 보냈습니다. 메일의 링크를 누른 뒤 로그인해 주세요.");
      setSubmitting(false);
      return;
    }
    // [Next] replace = 지금 화면을 /postings로 바꾸기(뒤로 가기에 로그인 화면이 안 남음). Flutter의 context.go
    router.replace("/postings");
    // [Next] refresh = 서버에 화면을 다시 요청. 새 쿠키(출입증)로 서버 컴포넌트가 다시 그려진다.
    router.refresh();
  }

  // [React] return 뒤의 ( ... ) = 화면. Flutter build()의 return 위젯 트리
  // [JSX] <form>, <label>, <input>, <button>, <p> = HTML 태그로 쓰는 화면 부품
  //       Flutter의 Form, TextFormField, ElevatedButton, Text 자리
  // [JSX] className = 스타일 이름 목록 (HTML의 class인데 JS 예약어와 겹쳐서 className)
  return (
    // [JSX] onSubmit={함수} = 제출하면 이 함수 실행. Flutter의 onPressed: _submit
    // [Tailwind] flex flex-col gap-3 = Column(spacing: 12)
    <form onSubmit={handleSubmit} className="flex flex-col gap-3">
      {/* [JSX] 화면 안의 주석은 이렇게 중괄호 + 슬래시별 */}
      {/* [Tailwind] text-sm = 작은 글씨, gap-1 = 간격 4px */}
      <label className="flex flex-col gap-1 text-sm">
        이메일
        {/* [JSX] <input> = 입력칸. TextFormField
            [웹] type="email" required = 브라우저가 이메일 형식·빈칸을 검사해 준다(validator 자리)
            [React] value={email} + onChange = 입력값을 상태와 묶기. TextEditingController 자리
                    e.target.value = 방금 입력된 글자 */}
        <input
          type="email"
          required
          autoComplete="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="rounded-md border border-zinc-300 px-3 py-2 text-base"
        />
        {/* [Tailwind] rounded-md = 모서리 둥글게, border = 테두리, px-3 py-2 = 좌우 12px 위아래 8px 여백 */}
      </label>
      <label className="flex flex-col gap-1 text-sm">
        비밀번호
        {/* [웹] minLength = 최소 글자 수 검사. 가입일 때만 6자 */}
        <input
          type="password"
          required
          minLength={isSignUp ? 6 : undefined}
          autoComplete={isSignUp ? "new-password" : "current-password"}
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="rounded-md border border-zinc-300 px-3 py-2 text-base"
        />
      </label>

      {/* [JSX] {조건 && <부품/>} = 조건이 참일 때만 보여 주기. Dart의 if (error != null) Text(error) */}
      {error && <p className="text-sm text-red-600">{error}</p>}
      {info && <p className="text-sm text-zinc-700">{info}</p>}

      {/* [웹] type="submit" = 이 버튼을 누르면 form의 onSubmit이 불린다 */}
      {/* [Tailwind] bg-indigo-700 = 배경색, text-white = 글자색, disabled:opacity-50 = 비활성화면 흐리게 */}
      <button
        type="submit"
        disabled={submitting}
        className="rounded-full bg-indigo-700 py-2 font-medium text-white disabled:opacity-50"
      >
        {/* [JSX] { } 안에는 TS 값을 넣는다. 여기선 삼항 연산자로 글자 고르기 */}
        {submitting ? "처리 중…" : isSignUp ? "가입하기" : "로그인"}
      </button>
      {/* [웹] type="button" = 제출이 아닌 그냥 버튼 */}
      {/* [JSX] onClick={() => { ... }} = 누르면 실행. Flutter의 onPressed: () { ... } */}
      <button
        type="button"
        disabled={submitting}
        onClick={() => {
          setMode(isSignUp ? "signIn" : "signUp");
          setError(null);
          setInfo(null);
        }}
        className="text-sm text-indigo-700"
      >
        {isSignUp ? "이미 계정이 있어요" : "처음이에요, 가입할게요"}
      </button>
    </form>
  );
}
