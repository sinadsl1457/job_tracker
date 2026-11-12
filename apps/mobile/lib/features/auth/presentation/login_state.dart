import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

enum LoginMode { signIn, signUp }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginMode.signIn) LoginMode mode,
    @Default(false) bool submitting,
    String? errorMessage,

    /// 가입은 됐지만 확인 메일을 눌러야 로그인되는 경우(클라우드 기본 설정).
    @Default(false) bool needsEmailConfirmation,
  }) = _LoginState;
}
