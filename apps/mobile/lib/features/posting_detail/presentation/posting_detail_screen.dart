import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/presentation/async_views.dart';
import '../../../core/time/clock.dart';
import '../../postings/data/job_posting.dart';
import '../../postings/presentation/postings_filter.dart';
import '../../postings/presentation/stage_chip.dart';
import 'posting_detail_notifier.dart';
import 'stage_change_sheet.dart';

class PostingDetailScreen extends ConsumerStatefulWidget {
  const PostingDetailScreen({required this.postingId, super.key});

  final String postingId;

  @override
  ConsumerState<PostingDetailScreen> createState() =>
      _PostingDetailScreenState();
}

class _PostingDetailScreenState extends ConsumerState<PostingDetailScreen> {
  bool _busy = false;

  PostingDetailNotifierProvider get _provider =>
      postingDetailProvider(widget.postingId);

  void _show(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) _show(done);
    } on AppFailure catch (e) {
      if (mounted) _show(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeStage(JobPosting posting) async {
    final choice = await showStageChangeSheet(
      context,
      current: posting.stage,
      lastChangedAt: posting.stageChangedAt,
      now: ref.read(clockProvider).now(),
    );
    if (choice == null || !mounted) return;
    await _run(
      () => ref.read(_provider.notifier).changeStage(choice.stage, choice.date),
      '${choice.stage.label}(으)로 바꿨습니다.',
    );
  }

  Future<void> _edit() async {
    final saved = await context.push<JobPosting>(
      '/postings/${widget.postingId}/edit',
    );
    if (saved != null) ref.invalidate(_provider);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공고를 삭제할까요?'),
        content: const Text('단계 이력도 함께 지워지고 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(_provider.notifier).delete();
      if (mounted) context.pop();
    } on AppFailure catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _show(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(_provider);
    final loaded = detail.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(loaded?.posting.company ?? ''),
        actions: [
          if (loaded != null) ...[
            IconButton(
              tooltip: '수정',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _busy ? null : _edit,
            ),
            IconButton(
              tooltip: '삭제',
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy ? null : _delete,
            ),
          ],
        ],
      ),
      body: detail.when(
        skipLoadingOnRefresh: false,
        loading: () => const LoadingView(),
        error: (error, _) =>
            ErrorView(error: error, onRetry: () => ref.invalidate(_provider)),
        data: (d) => _DetailBody(
          detail: d,
          busy: _busy,
          onChangeStage: () => _changeStage(d.posting),
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({
    required this.detail,
    required this.busy,
    required this.onChangeStage,
  });

  final PostingDetail detail;
  final bool busy;
  final VoidCallback onChangeStage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = detail.posting;
    final today = ref.watch(clockProvider).today();
    final textTheme = Theme.of(context).textTheme;
    final dDay = deadlineLabel(p.deadline, today);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text(p.position, style: textTheme.titleLarge)),
            StageChip(p.stage),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow('채널', p.channel.label),
        _InfoRow(
          '마감일',
          p.deadline == null ? '없음' : '${formatDate(p.deadline!)} ($dDay)',
        ),
        if (p.location != null) _InfoRow('근무지', p.location!),
        if (p.employmentType != null) _InfoRow('고용형태', p.employmentType!.label),
        if (p.url != null)
          _InfoRow(
            '공고 URL',
            p.url!,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: p.url!));
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('주소를 복사했습니다.')));
              }
            },
          ),
        if (p.memo != null) ...[
          const SizedBox(height: 8),
          Text('메모', style: textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(p.memo!),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: busy ? null : onChangeStage,
          icon: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.swap_horiz),
          label: const Text('단계 변경'),
        ),
        const SizedBox(height: 24),
        Text('단계 이력', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final e in detail.events.reversed)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.circle, size: 10),
            title: Text(
              e.fromStage == null
                  ? '${e.toStage.label} (등록)'
                  : '${e.fromStage!.label} → ${e.toStage.label}',
            ),
            trailing: Text(formatDate(e.changedAt)),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: Text(label, style: Theme.of(context).textTheme.labelLarge),
            ),
            Expanded(child: Text(value)),
            if (onTap != null) const Icon(Icons.copy, size: 16),
          ],
        ),
      ),
    );
  }
}
