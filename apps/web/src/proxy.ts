// 모든 요청이 화면에 닿기 전에 먼저 지나가는 문지기(예전 이름 middleware).
// 1. 만료된 출입증을 새로 받아 쿠키를 갱신하고  2. 로그인 안 했으면 /login으로 보낸다.
// Flutter로 치면 go_router의 redirect. 다만 이건 서버에서, 화면을 만들기 전에 돈다.

// [Next] 파일 이름이 proxy.ts이고 src/ 바로 아래 있으면 Next.js가 알아서 모든 요청 앞에 끼워 넣는다(규칙).
import { createServerClient } from "@supabase/ssr"; // [Supabase]
// [Next] NextRequest = 들어온 요청, NextResponse = 돌려보낼 응답
// [TS] type NextRequest = 타입만 가져온다는 표시(실행 코드에는 안 들어감)
import { type NextRequest, NextResponse } from "next/server";

import { supabasePublishableKey, supabaseUrl } from "./lib/supabase/env";

// [TS] ["/login"] = 배열. Dart의 List ['/login']
const publicPaths = ["/login"];

// [Next] export async function proxy(...) = 이 이름으로 내보내야 Next.js가 문지기로 쓴다.
// [TS] (request: NextRequest) = 인자 이름: 타입. Dart의 (NextRequest request)와 순서가 반대다.
export async function proxy(request: NextRequest) {
  // [TS] let = 나중에 바꿀 수 있는 변수. Dart의 var. (const는 final)
  // [Next] NextResponse.next() = "통과, 원래 가려던 화면으로 가라"
  let response = NextResponse.next({ request });

  // [Supabase] 문지기용 클라이언트. 쿠키를 요청에서 읽고 응답에 쓴다.
  const supabase = createServerClient(supabaseUrl, supabasePublishableKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet, headers) {
        // 갱신된 출입증을 이번 요청(화면이 읽음)과 응답(브라우저가 저장) 둘 다에 넣는다.
        cookiesToSet.forEach(({ name, value }) =>
          request.cookies.set(name, value),
        );
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) =>
          response.cookies.set(name, value, options),
        );
        // [TS] Object.entries(객체) = [이름, 값] 쌍 목록으로 바꾸기. Dart의 map.entries
        Object.entries(headers).forEach(([key, value]) =>
          response.headers.set(key, value),
        );
      },
    },
  });

  // [Supabase] 출입증 확인(필요하면 갱신). 이 호출과 위 createServerClient 사이에 다른 코드를 넣지 않는다.
  // [TS] const { data } = ... = 결과 객체에서 data만 꺼내기(구조 분해)
  const { data } = await supabase.auth.getClaims();
  // [TS] data?.claims = data가 비어 있으면 거기서 멈추고 undefined. Dart의 data?.claims와 같다.
  // [TS] != null = null도 undefined도 아니면. (JS에는 "없음"이 null, undefined 두 가지라서 != 로 둘 다 거른다)
  const signedIn = data?.claims != null;
  // [Next] request.nextUrl.pathname = 요청 주소의 경로 부분(/postings 등)
  const path = request.nextUrl.pathname;
  // [TS] some(...) = 하나라도 맞으면 true. Dart의 any(...)
  const isPublic = publicPaths.some((p) => path.startsWith(p));

  if (!signedIn && !isPublic) {
    return redirectKeepingCookies(request, response, "/login");
  }
  if (signedIn && isPublic) {
    return redirectKeepingCookies(request, response, "/postings");
  }
  return response;
}

// 다른 주소로 보내되, 방금 갱신한 출입증 쿠키는 잃지 않게 옮겨 담는다.
function redirectKeepingCookies(
  request: NextRequest,
  response: NextResponse,
  path: string, // [TS] string = Dart의 String
) {
  // [Next] NextResponse.redirect = "이 주소로 다시 가라"고 브라우저에 알리는 응답
  // [웹] new URL(경로, 기준주소) = 완전한 주소 만들기 (브라우저·Node 기본 기능)
  const redirect = NextResponse.redirect(new URL(path, request.url));
  response.cookies.getAll().forEach((cookie) => redirect.cookies.set(cookie));
  return redirect;
}

// [Next] config.matcher = 문지기가 어떤 주소에서 돌지 정하는 규칙. 그림·정적 파일은 건너뛴다.
export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
