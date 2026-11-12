// Riverpod 3는 기본으로 실패한 provider를 최대 10번 다시 시도해서 에러 화면이 늦게 뜬다.
// 자동 재시도는 끄고, 화면의 "다시 시도"·당겨서 새로고침으로 사용자가 고른다.
Duration? appRetry(int retryCount, Object error) => null;
