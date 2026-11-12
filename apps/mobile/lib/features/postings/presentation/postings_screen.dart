import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/presentation/async_views.dart';
import '../../../core/time/clock.dart';
import '../../auth/data/auth_providers.dart';
import '../data/job_posting.dart';
import '../data/posting_enums.dart';
import '../data/posting_providers.dart';
import 'postings_filter.dart';
import 'postings_filter_notifier.dart';
import 'stage_chip.dart';

class PostingsScreen extends ConsumerWidget {
  const PostingsScreen({super.key});

  static const path = '/postings';

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on AppFailure catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postings = ref.watch(postingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('지원 관리'),
        actions: [
          IconButton(
            tooltip: '로그아웃',
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '공고 등록',
        onPressed: () => context.push('${PostingsScreen.path}/new'),
        child: const Icon(Icons.add),
      ),
      body: postings.when(
        skipLoadingOnRefresh: false,
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(postingsProvider),
        ),
        data: (all) => RefreshIndicator(
          onRefresh: () => ref.refresh(postingsProvider.future),
          child: _PostingsList(all: all),
        ),
      ),
    );
  }
}

class _PostingsList extends ConsumerWidget {
  const _PostingsList({required this.all});

  final List<JobPosting> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(postingsFilterProvider);
    final today = ref.watch(clockProvider).today();
    final visible = applyPostingsFilter(all, filter, today: today);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: _FilterBar()),
        if (all.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('아직 등록한 공고가 없습니다.\n+ 버튼으로 추가해 보세요.')),
          )
        else if (visible.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('조건에 맞는 공고가 없습니다.')),
          )
        else
          SliverList.separated(
            itemCount: visible.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) =>
                _PostingTile(posting: visible[i], today: today),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 88)),
      ],
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(postingsFilterProvider);
    final notifier = ref.read(postingsFilterProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        spacing: 8,
        children: [
          PopupMenuButton<PostingSort>(
            tooltip: '정렬',
            onSelected: notifier.setSort,
            itemBuilder: (_) => [
              for (final sort in PostingSort.values)
                CheckedPopupMenuItem(
                  value: sort,
                  checked: sort == filter.sort,
                  child: Text(sort.label),
                ),
            ],
            child: Chip(
              avatar: const Icon(Icons.sort, size: 18),
              label: Text(filter.sort.label),
            ),
          ),
          PopupMenuButton<ApplicationStage?>(
            tooltip: '단계',
            onSelected: notifier.setStage,
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: null,
                checked: filter.stage == null,
                child: const Text('전체 단계'),
              ),
              for (final stage in ApplicationStage.values)
                CheckedPopupMenuItem(
                  value: stage,
                  checked: stage == filter.stage,
                  child: Text(stage.label),
                ),
            ],
            child: Chip(
              avatar: const Icon(Icons.filter_list, size: 18),
              label: Text(filter.stage?.label ?? '전체 단계'),
            ),
          ),
          for (final channel in JobChannel.values)
            FilterChip(
              label: Text(channel.label),
              selected: filter.channel == channel,
              onSelected: (_) => notifier.toggleChannel(channel),
            ),
        ],
      ),
    );
  }
}

class _PostingTile extends StatelessWidget {
  const _PostingTile({required this.posting, required this.today});

  final JobPosting posting;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final label = deadlineLabel(posting.deadline, today);
    final days = daysUntil(posting.deadline, today);
    // 아직 지원 전인데 마감이 하루 이내면 눈에 띄게
    final urgent =
        posting.stage == ApplicationStage.interested &&
        days != null &&
        days >= 0 &&
        days <= 1;
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      title: Text('${posting.company} · ${posting.position}'),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: posting.channel.label),
            if (label != null) ...[
              const TextSpan(text: ' · '),
              TextSpan(
                text: label,
                style: urgent
                    ? TextStyle(
                        color: colors.error,
                        fontWeight: FontWeight.bold,
                      )
                    : null,
              ),
            ],
            if (posting.location != null)
              TextSpan(text: ' · ${posting.location}'),
          ],
        ),
      ),
      trailing: StageChip(posting.stage),
    );
  }
}
