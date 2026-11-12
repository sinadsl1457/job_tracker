# job_tracker — 구직 지원 관리 (Flutter 앱 + Next.js 웹 + Supabase)

개인 포트폴리오. 내가 매일 쓰는 지원 관리 서비스이면서, 앱·웹·백엔드를 혼자 연결해 배포한 기록이다.
나는 Flutter 4년 차, 웹·백엔드는 처음이다 → 웹·백엔드 결정은 `docs/LEARNING.md`에 기록한다.

## 진행 방식
- 단계 순서: 1 DB·RLS·로컬 Supabase → 2 Flutter → 3 Next.js + Vercel → 4 푸시 → 5 AI 공고 분석 → 6 CI/README.
- 단계가 끝나면 멈추고 결과 요약 + 확인 방법(명령어·화면)을 보고한다. 승인 후 다음 단계.
- 스택 변경, 유료 서비스·결제 수단 등록, Android Gradle/AGP/Kotlin/Java 변경은 먼저 묻는다.
- 커밋은 기능 단위로 작게, 자연스러운 한국어로. AI 흔적이 드러나는 표현·`Co-Authored-By` 줄은 쓰지 않는다. squash·amend·force push 금지.
- 커밋 전: 앱은 `dart format` + `flutter analyze`, 웹은 lint + 타입 체크, DB는 `supabase test db`.
- `.env`·키·시크릿은 커밋하지 않는다. `.env.example`만 커밋.
- AI가 틀렸거나 방향을 바꾼 지점은 `docs/AI_LOG.md`에 바로 적는다.

## 구조
```
apps/mobile   Flutter
apps/web      Next.js (3단계)
supabase/     migrations, tests(pgTAP), scripts, functions(4·5단계), seed.sql
docs/         LEARNING.md, AI_LOG.md
```

## DB 규칙
- 공고 1개 = 지원 1건 → `job_postings`에 현재 단계(`stage`)까지 둔다. 테이블을 나눌 만큼 얻는 게 없다.
- 단계 이력(`application_events`)은 트리거가 쓴다. 클라이언트는 `stage`(필요하면 `stage_changed_at`)만 바꾼다. 이력 테이블에 클라이언트 쓰기 정책은 없다.
- 모든 테이블 RLS: `user_id = (select auth.uid())`. `user_id`는 기본값이 로그인 사용자라 클라이언트가 넣지 않는다.
- 스키마 변경은 항상 새 마이그레이션 파일로. 이미 커밋한 마이그레이션은 고치지 않는다.
- 통계 비율은 "그 단계에 한 번이라도 도달한 서로 다른 공고 수"로 센다(단계를 왔다 갔다 해도 부풀지 않게).
  - 열람률 = 열람 이상 ÷ 지원 이상, 서류 통과율 = 서류합격 이상 ÷ 지원 이상, 면접 전환율 = 1차면접 이상 ÷ 서류합격 이상
  - 주간 추이 = 처음 `applied`가 된 날짜의 주

## Flutter (apps/mobile)
- 최소 버전: Flutter 3.38 / `sdk: ^3.10.0`. 패키지는 추가할 때마다 3.38에서 `pub get`이 되는지 확인한다.
  - 그래서 flutter_riverpod 3.1 / riverpod_annotation 4.0.0~ / riverpod_generator 4.0.0 (4.0.3+는 Dart 3.12 필요).
- Riverpod 3 + `@riverpod` 코드 생성, go_router(`core/router/app_router.dart` 한 파일), freezed 3 + json_serializable.
- 서버 통신은 `supabase_flutter`만(dio 없음). Supabase 호출은 저장소 클래스 안에만 두고, Notifier·화면은 Supabase를 모른다.
- 폴더: `lib/core/{storage,analytics,time,router,presentation}`, `lib/features/<기능>/{data,presentation}`.
  - `auth`: 로그인 상태, 앱 전체 수명.
  - `postings`: 목록 + 필터. 필터 상태는 목록 화면이 가진다.
  - `posting_detail`: 상세 + 단계 변경 + 이력. 공고 id마다 생긴다(family).
  - `posting_form`: 등록·수정 입력. 화면을 닫으면 사라진다.
- 수명: Supabase 클라이언트·저장소는 `@Riverpod(keepAlive: true)`, 화면 Notifier는 `@riverpod`.
- `ProviderScope(retry: appRetry)`로 자동 재시도 규칙을 한 번 정한다. 테스트도 같은 규칙.
- Notifier: build에서 watch, 메서드에서 read, await 뒤 `if (!ref.mounted) return;`. 이동·스낵바는 화면이 `ref.listen`으로.
- initState·build에서 provider 상태를 바꾸지 않는다(처음 값은 family 인자로).
- 시간은 `clockProvider`. 생성 파일(.g.dart, .freezed.dart)은 커밋한다.
- Android·iOS 빌드 설정은 템플릿 기본값 유지.
