// 공고·단계 데이터의 모양(타입)과 한국어 이름표. 앱의 posting_enums.dart + job_posting.dart와 같은 내용.
// DB enum과 1:1로 맞춘다(supabase/migrations/..._create_tables.sql).

// [TS] as const = 이 배열의 값들을 글자 그대로 고정한다. 아래에서 이 배열로 타입을 만들기 위해 붙인다.
export const STAGES = [
  "interested",
  "applied",
  "viewed",
  "doc_passed",
  "assignment",
  "interview_1",
  "interview_2",
  "final_passed",
  "rejected",
  "on_hold",
] as const;

// [TS] (typeof STAGES)[number] = "STAGES 배열 안의 값 중 하나"라는 타입.
//      결과는 "interested" | "applied" | ... 이다. Dart의 enum ApplicationStage 자리.
export type Stage = (typeof STAGES)[number];

export const CHANNELS = ["jobkorea", "wanted", "saramin", "other"] as const;
export type Channel = (typeof CHANNELS)[number];

export type EmploymentType =
  | "full_time"
  | "contract"
  | "intern"
  | "freelance"
  | "other";

// [TS] Record<키타입, 값타입> = 모든 키에 값이 있는 객체. Dart의 Map<Stage, String>인데 빠진 키가 있으면 타입 에러가 난다.
export const STAGE_LABEL: Record<Stage, string> = {
  interested: "관심",
  applied: "지원",
  viewed: "열람",
  doc_passed: "서류합격",
  assignment: "과제",
  interview_1: "1차면접",
  interview_2: "2차면접",
  final_passed: "최종합격",
  rejected: "불합격",
  on_hold: "보류",
};

// 진행 순서. 불합격·보류는 순서 밖이라 null. (앱의 ApplicationStage.progress)
export const STAGE_PROGRESS: Record<Stage, number | null> = {
  interested: 0,
  applied: 1,
  viewed: 2,
  doc_passed: 3,
  assignment: 4,
  interview_1: 5,
  interview_2: 6,
  final_passed: 7,
  rejected: null,
  on_hold: null,
};

export const CHANNEL_LABEL: Record<Channel, string> = {
  jobkorea: "잡코리아",
  wanted: "원티드",
  saramin: "사람인",
  other: "기타",
};

export const EMPLOYMENT_TYPE_LABEL: Record<EmploymentType, string> = {
  full_time: "정규직",
  contract: "계약직",
  intern: "인턴",
  freelance: "프리랜서",
  other: "기타",
};

// [TS] type 이름 = { 칸: 타입; ... } = 객체의 모양. Dart의 freezed JobPosting 클래스 자리.
//      Supabase가 돌려주는 JSON을 그대로 쓰므로 칸 이름도 DB와 같은 snake_case다(앱은 fromJson으로 바꿨음).
export type Posting = {
  id: string;
  company: string;
  position: string;
  url: string | null;
  channel: Channel;
  deadline: string | null; // "2026-11-13" (날짜만)
  location: string | null;
  employment_type: EmploymentType | null;
  memo: string | null;
  stage: Stage;
  stage_changed_at: string; // ISO 시각 문자열
  created_at: string;
  updated_at: string;
};

export type StageEvent = {
  id: number;
  posting_id: string;
  from_stage: Stage | null;
  to_stage: Stage;
  changed_at: string;
};
