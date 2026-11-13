// 브라우저(클라이언트 컴포넌트)용 Supabase. 로그인하면 출입증을 쿠키에 저장한다.
// Flutter로 치면 Supabase.instance.client.

// [TS] import { 이름 } from "패키지" = 패키지에서 필요한 것만 가져오기. Dart의 import 'package:...' show 이름;
// [Supabase] @supabase/ssr = 출입증을 쿠키에 넣고 꺼내 주는 Supabase 공식 패키지
import { createBrowserClient } from "@supabase/ssr";

// [TS] "./env" = 같은 폴더의 env.ts 파일 (확장자는 안 씀)
import { supabasePublishableKey, supabaseUrl } from "./env";

// [TS] export function 이름() { ... } = 공개 함수. Dart의 SupabaseClient createClient() { ... }
export function createClient() {
  // [Supabase] 브라우저용 클라이언트 만들기. 로그인·로그아웃하면 브라우저 쿠키를 알아서 고친다.
  return createBrowserClient(supabaseUrl, supabasePublishableKey);
}
