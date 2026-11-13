// Supabase 접속 정보.
//
// 꼬리표: [TS] TypeScript 문법  [React] React 기능  [JSX] 화면 문법  [Next] Next.js 기능
//        [Supabase] Supabase 패키지  [Tailwind] 스타일  [웹] 브라우저·HTML 기본 기능

// [TS] export = 다른 파일에서 import로 가져다 쓸 수 있게 공개. (Dart는 기본 공개라 이런 표시가 없음)
// [TS] const = 바꿀 수 없는 값. Dart의 final과 같다.
// [Next] process.env.이름 = .env.local 파일에 적은 값을 읽는다.
//        이름이 NEXT_PUBLIC_으로 시작하면 빌드 때 코드에 그대로 박혀 브라우저로도 내려간다 → 공개 키만 넣는다.
// [TS] 끝의 ! = "비어 있지 않다고 내가 보장한다". Dart의 value! 와 같다.
export const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
export const supabasePublishableKey =
  process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!;
