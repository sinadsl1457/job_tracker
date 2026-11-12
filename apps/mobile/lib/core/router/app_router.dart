// 앱의 모든 경로. 로그인 상태가 바뀌면 redirect가 다시 돌아 로그인/목록으로 보낸다.
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/posting_form/presentation/posting_form_screen.dart';
import '../../features/postings/presentation/postings_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  final signedIn = ValueNotifier<bool>(auth.isSignedIn);
  final subscription = auth.watchSignedIn().listen((v) => signedIn.value = v);

  final router = GoRouter(
    initialLocation: PostingsScreen.path,
    refreshListenable: signedIn,
    redirect: (context, state) {
      final atLogin = state.matchedLocation == LoginScreen.path;
      if (!signedIn.value) return atLogin ? null : LoginScreen.path;
      if (atLogin) return PostingsScreen.path;
      return null;
    },
    routes: [
      GoRoute(
        path: LoginScreen.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: PostingsScreen.path,
        builder: (context, state) => const PostingsScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const PostingFormScreen(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    subscription.cancel();
    signedIn.dispose();
    router.dispose();
  });
  return router;
}
