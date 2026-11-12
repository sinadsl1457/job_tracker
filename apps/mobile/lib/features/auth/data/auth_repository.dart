// 이메일·비밀번호 로그인. Supabase Auth 호출은 이 클래스 안에만 둔다.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/app_failure.dart';

enum SignUpResult { signedIn, needsEmailConfirmation }

class AuthRepository {
  AuthRepository(this._auth);

  final GoTrueClient _auth;

  bool get isSignedIn => _auth.currentSession != null;

  String? get currentEmail => _auth.currentUser?.email;

  /// 로그인·로그아웃·토큰 만료로 상태가 바뀔 때마다 알린다.
  Stream<bool> watchSignedIn() =>
      _auth.onAuthStateChange.map((state) => state.session != null);

  Future<void> signIn({required String email, required String password}) =>
      _guard(() => _auth.signInWithPassword(email: email, password: password));

  /// 클라우드는 기본으로 가입 확인 메일을 보낸다. 그때는 세션 없이 돌아온다.
  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) => _guard(() async {
    final response = await _auth.signUp(email: email, password: password);
    return response.session == null
        ? SignUpResult.needsEmailConfirmation
        : SignUpResult.signedIn;
  });

  Future<void> signOut() => _guard(_auth.signOut);

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}

final class AuthFailure extends AppFailure {
  const AuthFailure(this.message);

  factory AuthFailure.fromCode(String? code) => AuthFailure(switch (code) {
    'invalid_credentials' => '이메일 또는 비밀번호가 맞지 않습니다.',
    'user_already_exists' || 'email_exists' => '이미 가입된 이메일입니다.',
    'weak_password' => '비밀번호가 너무 짧습니다. 6자 이상으로 해 주세요.',
    'email_not_confirmed' => '메일함에서 가입 확인 링크를 먼저 눌러 주세요.',
    'over_request_rate_limit' ||
    'over_email_send_rate_limit' => '요청이 너무 많습니다. 잠시 뒤 다시 시도해 주세요.',
    _ => '로그인 처리 중 문제가 생겼습니다. ($code)',
  });

  @override
  final String message;
}
