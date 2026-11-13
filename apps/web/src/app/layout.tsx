// 모든 화면을 감싸는 공통 틀. Flutter로 치면 MaterialApp(제목, 테마, 글꼴).
// [Next] 파일 이름 규칙: app/layout.tsx는 모든 page.tsx를 감싼다. 화면이 바뀌어도 layout은 그대로 남는다.

// [TS] import type = 타입만 가져오기
// [Next] Metadata = 브라우저 탭 제목 등 페이지 정보의 타입
import type { Metadata } from "next";
// [Next] next/font/google = 구글 글꼴을 빌드 때 받아서 우리 서버에서 함께 보내 주는 기능
import { Geist, Geist_Mono } from "next/font/google";
// [Next] CSS 파일을 import하면 전체 화면에 적용된다. Flutter의 ThemeData를 앱 전체에 거는 것
import "./globals.css";

// TanStack Query 창고(클라이언트 컴포넌트). 모든 화면을 이걸로 감싼다.
import { Providers } from "./providers";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

// [Next] metadata라는 이름으로 내보내면 브라우저 탭 제목·설명이 된다. MaterialApp(title: ...)
export const metadata: Metadata = {
  title: "지원 관리",
  description: "채용 공고와 지원 단계를 관리한다",
};

// [Next] layout의 대표 함수. children = 지금 주소의 page.tsx 화면이 여기 들어온다.
// [React] children = 감싸는 부품 안에 들어갈 내용. Flutter의 child
// [TS] { children }: LayoutProps<"/"> = 인자 객체에서 children을 꺼내고, 그 타입은 Next.js가 만들어 준 LayoutProps
export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    // [JSX] <html>, <body> = 웹 페이지의 가장 바깥 껍데기 (모든 웹 페이지에 있는 기본 구조)
    // [웹] lang="ko" = 이 페이지는 한국어라고 브라우저·검색엔진에 알림. MaterialApp(locale: ko)
    // [JSX] className={`...${값}...`} = 스타일 이름에 TS 값을 끼워 넣기
    // [Tailwind] h-full = 높이 100%, antialiased = 글자 매끄럽게
    <html
      lang="ko"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      {/* [Tailwind] min-h-full flex flex-col = 화면 높이를 꽉 채우는 Column */}
      <body className="min-h-full flex flex-col">
        {/* [React] Providers로 감싸야 그 안의 화면들이 TanStack Query를 쓸 수 있다. Flutter의 ProviderScope(child: App()) */}
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
