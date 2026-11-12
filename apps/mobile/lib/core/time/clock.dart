// 현재 시각. 테스트에서 고정 시각으로 바꿔 끼운다.
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

class Clock {
  const Clock();

  DateTime now() => DateTime.now();

  DateTime today() => DateUtils.dateOnly(now());
}

class FixedClock extends Clock {
  const FixedClock(this.fixed);

  final DateTime fixed;

  @override
  DateTime now() => fixed;
}

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const Clock();
