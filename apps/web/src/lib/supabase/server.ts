// 서버(서버 컴포넌트)용 Supabase. 요청에 딸려 온 쿠키에서 출입증을 꺼내 쓰므로 RLS가 그대로 걸린다.
// Flutter에는 해당하는 것이 없다(앱은 서버 코드가 없으니까).

// [Next] "server-only" = 이 파일을 실수로 브라우저 코드에서 import하면 빌드 에러를 낸다(서버 전용 표시).
import "server-only";

// [Supabase] 서버용 클라이언트 만드는 함수
import { createServerClient } from "@supabase/ssr";
// [Next] cookies() = 지금 들어온 요청의 쿠키를 읽는 Next.js 함수. 서버에서만 쓸 수 있다.
import { cookies } from "next/headers";

import { supabasePublishableKey, supabaseUrl } from "./env";

// [TS] async function = 기다림(await)이 있는 함수. Dart의 Future<...> createClient() async { ... }
export async function createClient() {
  // [TS] await = 끝날 때까지 기다리기. Dart와 같다.
  const cookieStore = await cookies();

  // [Supabase] 쿠키를 어떻게 읽고 쓰는지 알려 주며 클라이언트를 만든다.
  // [TS] { cookies: { ... } } = 객체(이름: 값 묶음). Dart의 Map이나 이름 있는 인자와 비슷하다.
  return createServerClient(supabaseUrl, supabasePublishableKey, {
    cookies: {
      // [TS] getAll() { ... } = 객체 안에 함수를 바로 정의 (콜백을 넘기는 것)
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        // 서버 컴포넌트는 화면을 그리는 중에 쿠키를 쓸 수 없다. 출입증 갱신은 proxy.ts가 맡으므로 무시해도 된다.
        // [TS] try { } catch { } = Dart의 try { } catch (_) { }
        try {
          // [TS] forEach(({ name, value, options }) => ...) = 목록을 돌며 처리.
          //      ({ name, value }) 는 객체에서 그 이름의 값만 꺼내는 문법(구조 분해). Dart 3의 패턴 매칭과 비슷하다.
          //      => 는 Dart의 화살표 함수와 같다.
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options),
          );
        } catch {}
      },
    },
  });
}
