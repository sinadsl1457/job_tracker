// 목록 위 한 줄 통계. 자세한 차트는 웹 대시보드에서 본다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/funnel_stats.dart';
import '../data/posting_providers.dart';

class FunnelSummary extends ConsumerWidget {
  const FunnelSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(allStageEventsProvider);
    final textTheme = Theme.of(context).textTheme;

    final Widget content = switch (events) {
      AsyncData(:final value) => _Numbers(FunnelStats.fromEvents(value)),
      AsyncError() => Text('통계를 불러오지 못했습니다.', style: textTheme.bodySmall),
      _ => const SizedBox(height: 40),
    };

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: content,
      ),
    );
  }
}

class _Numbers extends StatelessWidget {
  const _Numbers(this.stats);

  final FunnelStats stats;

  @override
  Widget build(BuildContext context) {
    if (stats.applied == 0) {
      return const Text('아직 지원한 공고가 없습니다.');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Stat('지원', '${stats.applied}건'),
        _Stat('열람률', _percent(stats.viewRate)),
        _Stat('서류 통과율', _percent(stats.docPassRate)),
        _Stat('면접 전환율', _percent(stats.interviewRate)),
      ],
    );
  }

  static String _percent(double? rate) =>
      rate == null ? '-' : '${(rate * 100).round()}%';
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.titleMedium),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
