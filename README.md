# job_tracker

채용 공고를 등록하고 지원 단계를 관리하는 서비스. Flutter 앱과 Next.js 웹이 같은 Supabase 계정과 DB를 쓴다.

> 진행 중 — 1단계(DB·RLS·로컬 Supabase) 완료. 화면 캡처, 배포 URL, 아키텍처 다이어그램은 단계가 진행되면서 채운다.

## 필요 환경
| 도구 | 버전 |
|---|---|
| Flutter | 3.38 이상 (`sdk: ^3.10.0`), 확인된 최소 버전은 2단계 후 기록 |
| Node | 24 LTS (3단계부터) |
| Supabase CLI | 3.x |
| Docker 실행기 | OrbStack / Docker Desktop / Colima 중 하나 |

## 로컬 실행
```bash
# 1. 로컬 Supabase (처음엔 이미지 다운로드로 몇 분 걸림)
supabase start
supabase db reset            # 마이그레이션 + 시드(테스트 계정 2개) 적용

# 2. DB 검증
supabase test db             # RLS·단계 이력 트리거 테스트(pgTAP)
./supabase/scripts/check_rls.sh   # 앱과 같은 경로(REST + 로그인)로 RLS 확인

# 관리 화면: http://127.0.0.1:54323 (Studio), 메일함: http://127.0.0.1:54324
# 시드 계정: me@test.local / other@test.local, 비밀번호 password123
```

## DB 구조
| 테이블 | 내용 |
|---|---|
| `profiles` | 사용자 (가입 시 트리거로 생성) |
| `job_postings` | 공고 + 현재 지원 단계. 혼자 쓰는 서비스라 공고 1개 = 지원 1건 |
| `application_events` | 단계 변경 이력. `stage`가 바뀌면 트리거가 기록, 클라이언트는 읽기만 |
| `skills` | 내 보유 기술 (5단계 공고 분석 비교용) |

모든 테이블에 RLS: 본인 행만 읽고 쓴다. 정책은 `supabase/migrations/`에 있다.

## 기록
- [docs/LEARNING.md](docs/LEARNING.md) — 웹·백엔드 개념과 결정 이유
- [docs/AI_LOG.md](docs/AI_LOG.md) — AI가 틀렸거나 방향을 바꾼 지점
