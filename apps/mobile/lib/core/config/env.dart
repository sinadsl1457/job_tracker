// 빌드할 때 넣는 접속 정보. flutter run --dart-define-from-file=env/local.json
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static void ensureConfigured() {
    if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
      throw StateError(
        'SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY가 비어 있다. '
        'env/local.example.json을 env/local.json으로 복사해 채우고 '
        '--dart-define-from-file=env/local.json으로 실행한다.',
      );
    }
  }
}
