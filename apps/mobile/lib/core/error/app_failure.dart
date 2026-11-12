// 저장소가 던지는 실패 종류. 화면은 이 타입만 보고 문구를 고른다.
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppFailure implements Exception {
  const AppFailure();

  String get message;

  /// Supabase·네트워크 예외를 앱 실패로 바꾼다. 이미 AppFailure면 그대로.
  static AppFailure from(Object error) => switch (error) {
    AppFailure() => error,
    SocketException() ||
    http.ClientException() ||
    TimeoutException() => const NetworkFailure(),
    PostgrestException(code: 'PGRST116') => const NotFoundFailure(),
    PostgrestException(:final message) => ServerFailure(message),
    AuthException(:final message) => ServerFailure(message),
    _ => ServerFailure(error.toString()),
  };
}

/// 연결 실패·타임아웃. 다시 시도하면 될 수 있다.
final class NetworkFailure extends AppFailure {
  const NetworkFailure();

  @override
  String get message => '서버에 연결하지 못했습니다. 네트워크를 확인해 주세요.';
}

/// 서버가 요청을 거절했거나 처리하지 못했다.
final class ServerFailure extends AppFailure {
  const ServerFailure(this.detail);

  final String detail;

  @override
  String get message => '서버 오류가 발생했습니다. ($detail)';
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure();

  @override
  String get message => '공고를 찾을 수 없습니다. 삭제되었을 수 있습니다.';
}

/// DB 트리거가 거부한 단계 변경 날짜(미래, 이전 단계보다 빠름).
final class StageDateRejectedFailure extends AppFailure {
  const StageDateRejectedFailure();

  @override
  String get message => '변경 날짜는 이전 단계 이후, 오늘 이전이어야 합니다.';
}
