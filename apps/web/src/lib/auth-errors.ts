// Supabase Auth 에러 코드 → 한국어 문구. 앱(auth_repository.dart)과 같은 문구를 쓴다.
// 화면이 없는 순수 TypeScript 파일이라 확장자가 .ts (화면이 있으면 .tsx)

// [TS] (code: string | undefined) = code는 문자열이거나 undefined(없음). Dart의 String? code
// [TS] : string = 돌려주는 값의 타입. Dart에서는 함수 이름 앞에 쓰는 String을 TS는 뒤에 쓴다.
export function authErrorMessage(code: string | undefined): string {
  // [TS] switch / case / return = Dart의 switch와 거의 같다.
  switch (code) {
    case "invalid_credentials":
      return "이메일 또는 비밀번호가 맞지 않습니다.";
    case "user_already_exists":
    case "email_exists":
      return "이미 가입된 이메일입니다.";
    case "weak_password":
      return "비밀번호가 너무 짧습니다. 6자 이상으로 해 주세요.";
    case "email_not_confirmed":
      return "메일함에서 가입 확인 링크를 먼저 눌러 주세요.";
    case "over_request_rate_limit":
    case "over_email_send_rate_limit":
      return "요청이 너무 많습니다. 잠시 뒤 다시 시도해 주세요.";
    default:
      // [TS] `...${값}...` = 백틱 문자열에 값 끼워 넣기. Dart의 '...${값}...'
      // [TS] code ?? "알 수 없음" = code가 없으면 오른쪽 값. Dart의 ?? 와 같다.
      return `로그인 처리 중 문제가 생겼습니다. (${code ?? "알 수 없음"})`;
  }
}
