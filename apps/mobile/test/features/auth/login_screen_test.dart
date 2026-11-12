import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/riverpod/app_retry.dart';
import 'package:job_tracker/features/auth/data/auth_providers.dart';
import 'package:job_tracker/features/auth/data/auth_repository.dart';
import 'package:job_tracker/features/auth/presentation/login_screen.dart';

class FakeAuthRepository implements AuthRepository {
  Object? signInError;
  SignUpResult signUpResult = SignUpResult.signedIn;
  final calls = <String>[];

  @override
  Future<void> signIn({required String email, required String password}) async {
    calls.add('signIn:$email');
    if (signInError != null) throw signInError!;
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    calls.add('signUp:$email');
    return signUpResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAuthRepository auth;

  Future<void> pumpLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: appRetry,
        overrides: [authRepositoryProvider.overrideWithValue(auth)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  setUp(() => auth = FakeAuthRepository());

  testWidgets('빈 칸으로 누르면 입력 안내가 나오고 서버를 부르지 않는다', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('로그인'));
    await tester.pump();

    expect(find.text('이메일을 입력해 주세요.'), findsOneWidget);
    expect(find.text('비밀번호를 입력해 주세요.'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('비밀번호가 틀리면 한국어 실패 문구를 보여 준다', (tester) async {
    auth.signInError = AuthFailure.fromCode('invalid_credentials');
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const Key('login-email')),
      ' me@test.local ',
    );
    await tester.enterText(find.byKey(const Key('login-password')), 'wrong');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(auth.calls, ['signIn:me@test.local']);
    expect(find.text('이메일 또는 비밀번호가 맞지 않습니다.'), findsOneWidget);
  });

  testWidgets('가입 후 확인 메일이 필요하면 안내를 보여 준다', (tester) async {
    auth.signUpResult = SignUpResult.needsEmailConfirmation;
    await pumpLogin(tester);

    await tester.tap(find.text('처음이에요, 가입할게요'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('login-email')),
      'new@test.local',
    );
    await tester.enterText(find.byKey(const Key('login-password')), '12345');
    await tester.tap(find.text('가입하기'));
    await tester.pump();
    expect(find.text('6자 이상으로 해 주세요.'), findsOneWidget);
    expect(auth.calls, isEmpty);

    await tester.enterText(find.byKey(const Key('login-password')), '123456');
    await tester.tap(find.text('가입하기'));
    await tester.pumpAndSettle();

    expect(auth.calls, ['signUp:new@test.local']);
    expect(find.textContaining('가입 확인 메일을 보냈습니다'), findsOneWidget);
  });
}
