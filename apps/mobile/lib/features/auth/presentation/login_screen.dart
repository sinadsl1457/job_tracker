import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_notifier.dart';
import 'login_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ref
        .read(loginProvider.notifier)
        .submit(email: _email.text.trim(), password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final isSignUp = state.mode == LoginMode.signUp;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '지원 관리',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const Key('login-email'),
                    controller: _email,
                    decoration: const InputDecoration(labelText: '이메일'),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return '이메일을 입력해 주세요.';
                      if (!v.contains('@')) return '이메일 형식이 아닙니다.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('login-password'),
                    controller: _password,
                    decoration: const InputDecoration(labelText: '비밀번호'),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      final v = value ?? '';
                      if (v.isEmpty) return '비밀번호를 입력해 주세요.';
                      if (isSignUp && v.length < 6) return '6자 이상으로 해 주세요.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (state.needsEmailConfirmation)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text('가입 확인 메일을 보냈습니다. 메일의 링크를 누른 뒤 로그인해 주세요.'),
                    ),
                  FilledButton(
                    onPressed: state.submitting ? null : _submit,
                    child: state.submitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isSignUp ? '가입하기' : '로그인'),
                  ),
                  TextButton(
                    onPressed: state.submitting
                        ? null
                        : ref.read(loginProvider.notifier).toggleMode,
                    child: Text(isSignUp ? '이미 계정이 있어요' : '처음이에요, 가입할게요'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
