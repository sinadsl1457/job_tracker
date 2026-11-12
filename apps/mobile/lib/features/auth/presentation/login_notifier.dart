// 로그인 화면 상태. 성공하면 라우터가 로그인 상태를 보고 목록으로 보낸다(여기서 이동하지 않음).
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../data/auth_providers.dart';
import '../data/auth_repository.dart';
import 'login_state.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState();

  void toggleMode() {
    state = LoginState(
      mode: state.mode == LoginMode.signIn
          ? LoginMode.signUp
          : LoginMode.signIn,
    );
  }

  Future<void> submit({required String email, required String password}) async {
    if (state.submitting) return;
    state = state.copyWith(
      submitting: true,
      errorMessage: null,
      needsEmailConfirmation: false,
    );
    final repository = ref.read(authRepositoryProvider);
    try {
      var needsConfirmation = false;
      if (state.mode == LoginMode.signIn) {
        await repository.signIn(email: email, password: password);
      } else {
        final result = await repository.signUp(
          email: email,
          password: password,
        );
        needsConfirmation = result == SignUpResult.needsEmailConfirmation;
      }
      if (!ref.mounted) return;
      state = state.copyWith(
        submitting: false,
        needsEmailConfirmation: needsConfirmation,
      );
    } on AppFailure catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(submitting: false, errorMessage: e.message);
    }
  }
}
