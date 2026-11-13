// [Next] TanStack Query는 브라우저에서 돌아서 클라이언트 컴포넌트여야 한다.
"use client";
// 앱 전체에 TanStack Query 창고를 깔아 둔다. Flutter의 main()에서 ProviderScope로 감싸는 것과 같다.

// [React] QueryClient = 불러온 데이터를 보관하는 창고, QueryClientProvider = 그 창고를 아래 화면들에 나눠 주는 부품
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
// [React] ReactNode = "화면에 넣을 수 있는 무엇이든"의 타입. Flutter의 Widget
import { type ReactNode, useState } from "react";

export function Providers({ children }: { children: ReactNode }) {
  // [React] useState(() => new QueryClient(...)) = 처음 한 번만 만들고 계속 같은 창고를 쓴다.
  //         (그냥 new QueryClient()라고 쓰면 화면을 다시 그릴 때마다 새 창고가 생겨 캐시가 날아간다)
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            // 실패하면 자동으로 3번 다시 시도하는 게 기본값이라 에러 화면이 늦게 뜬다.
            // 앱의 appRetry처럼 자동 재시도를 끄고 "다시 시도" 버튼으로 사용자가 고르게 한다.
            retry: false,
            // 30초 동안은 캐시를 "신선하다"고 보고 다시 묻지 않는다.
            staleTime: 30_000,
          },
        },
      }),
  );

  return (
    // [JSX] 감싸는 부품. children(아래 모든 화면)이 이 창고를 쓸 수 있게 된다.
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
}
