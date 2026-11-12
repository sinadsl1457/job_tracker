// 불러오는 중·실패 화면 공통 위젯.
import 'package:flutter/material.dart';

import '../error/app_failure.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppFailure.from(error).message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  final d = date.toLocal();
  return '${d.year}.${_two(d.month)}.${_two(d.day)}';
}

String _two(int n) => n.toString().padLeft(2, '0');
