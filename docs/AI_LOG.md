# AI 작업 기록

AI가 틀렸거나 내가 방향을 바꾼 지점. 형식: 무엇이 틀렸나 / 어떻게 확인했나 / 어떻게 고쳤나.

## 2026-11-12 (1단계)

### 방향 변경: dio를 빼고 supabase_flutter만 쓰기
- **제안:** AI가 스택에서 dio를 빼자고 했다. 처음엔 "Flutter에서 dio는 거의 다 쓰는데, 실서비스 수준에 맞나?" 하고 의심했다.
- **확인:** 백엔드 개발자가 만든 API를 부르는 상황과 Supabase를 쓰는 상황을 나눠서 비교했다. dio로 Supabase REST를 직접 부르면 토큰 갱신을 다시 만들어야 하고, 로그인 때문에 SDK도 결국 필요하다.
- **결정:** supabase_flutter만 쓴다. 호출은 저장소 클래스 안에 가둬서 나중에 바꿀 수 있게 한다(`docs/LEARNING.md`).

### 틀림: 최신 Riverpod 버전이 최소 Flutter(3.38)에서 설치되지 않음
- **틀린 것:** 처음 `pub add`에서 최신 범위(`riverpod_annotation ^4.0.3`, `json_annotation ^4.12.0`)를 그대로 박았다. 전역 메모의 "flutter_riverpod 3.4"도 3.38에서는 안 된다.
- **확인:** Flutter 3.38.10으로 `pub get` → `riverpod_generator`가 `meta ^1.18.0`을 요구하는데, Flutter 3.38 SDK는 `meta 1.17.0`에 고정돼 있어서 실패했다. `flutter_riverpod 3.4.1+`도 Dart 3.12 이상을 요구한다.
- **고친 것:** 하한을 `flutter_riverpod ^3.0.0`, `riverpod_annotation ^4.0.0`, `json_annotation ^4.9.0`, `freezed_annotation ^3.0.0`으로 낮추고 3.38에서 다시 풀었다. 결과: riverpod 3.1.0 / generator 4.0.0+1 / freezed 3.2.3 / json_serializable 6.11.2.

### 틀림: 시드 데이터의 단계 날짜가 거꾸로 감
- **틀린 것:** 시드에서 고래헬스를 "관심 10/28 → 지원 10/26"으로 넣었다. 등록일은 15일 전, 지원일은 17일 전으로 숫자를 잘못 골랐다.
- **확인:** `db reset` 뒤 이력을 공고별로 조회해서 날짜 순서를 눈으로 확인했다. 테스트는 다 통과한 상태였다.
- **고친 것:** 시드 숫자만 고치면 앱에서 날짜를 직접 고를 때 같은 일이 또 생긴다. 그래서 트리거에 "이전 단계보다 빠른 날짜는 거부" 규칙을 넣었다. 먼저 이 경우를 pgTAP 테스트로 추가해서 고치기 전에 실패하는 것을 확인했다. 그런 다음 트리거와 시드를 고쳤다.
