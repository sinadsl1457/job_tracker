// 단계와 바뀐 날짜를 고르는 바텀시트. 고른 값을 돌려주기만 하고 저장은 상세 화면이 한다.
import 'package:flutter/material.dart';

import '../../../core/presentation/async_views.dart';
import '../../postings/data/posting_enums.dart';
import '../data/stage_change_rule.dart';

typedef StageChoice = ({ApplicationStage stage, DateTime date});

Future<StageChoice?> showStageChangeSheet(
  BuildContext context, {
  required ApplicationStage current,
  required DateTime lastChangedAt,
  required DateTime now,
}) => showModalBottomSheet<StageChoice>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _StageChangeSheet(
    current: current,
    lastChangedAt: lastChangedAt,
    now: now,
  ),
);

class _StageChangeSheet extends StatefulWidget {
  const _StageChangeSheet({
    required this.current,
    required this.lastChangedAt,
    required this.now,
  });

  final ApplicationStage current;
  final DateTime lastChangedAt;
  final DateTime now;

  @override
  State<_StageChangeSheet> createState() => _StageChangeSheetState();
}

class _StageChangeSheetState extends State<_StageChangeSheet> {
  ApplicationStage? _stage;
  late DateTime _date = DateUtils.dateOnly(widget.now);

  StageChangeError? get _error {
    final stage = _stage;
    if (stage == null) return null;
    return checkStageChange(
      current: widget.current,
      next: stage,
      at: stageChangeTime(_date, widget.now),
      lastChangedAt: widget.lastChangedAt,
      now: widget.now,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateUtils.dateOnly(widget.lastChangedAt.toLocal()),
      lastDate: DateUtils.dateOnly(widget.now),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final isToday = DateUtils.isSameDay(_date, widget.now);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('단계 변경', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('지금: ${widget.current.label}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final stage in ApplicationStage.values)
                  ChoiceChip(
                    label: Text(stage.label),
                    selected: _stage == stage,
                    onSelected: stage == widget.current
                        ? null
                        : (_) => setState(() => _stage = stage),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('바뀐 날짜'),
              subtitle: Text('${formatDate(_date)}${isToday ? ' (오늘)' : ''}'),
              trailing: const Text('바꾸기'),
              onTap: _pickDate,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  error.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            FilledButton(
              onPressed: _stage == null || error != null
                  ? null
                  : () =>
                        Navigator.of(context)
                            .pop<StageChoice>((stage: _stage!, date: _date)),
              child: const Text('변경'),
            ),
          ],
        ),
      ),
    );
  }
}
