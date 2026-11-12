import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/presentation/async_views.dart';
import '../../../core/time/clock.dart';
import '../../postings/data/job_posting.dart';
import '../../postings/data/posting_enums.dart';
import 'posting_form_notifier.dart';

class PostingFormScreen extends ConsumerWidget {
  const PostingFormScreen({this.postingId, super.key});

  /// null이면 새 공고 등록.
  final String? postingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = postingFormProvider(postingId);
    final initial = ref.watch(provider);

    final title = postingId == null ? '공고 등록' : '공고 수정';

    return initial.when(
      skipLoadingOnRefresh: false,
      loading: () => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const LoadingView(),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ErrorView(error: error, onRetry: () => ref.invalidate(provider)),
      ),
      data: (draft) => _PostingForm(
        title: title,
        initial: draft,
        onSave: ref.read(provider.notifier).save,
      ),
    );
  }
}

class _PostingForm extends ConsumerStatefulWidget {
  const _PostingForm({
    required this.title,
    required this.initial,
    required this.onSave,
  });

  final String title;
  final PostingDraft initial;
  final Future<JobPosting> Function(PostingDraft) onSave;

  @override
  ConsumerState<_PostingForm> createState() => _PostingFormState();
}

class _PostingFormState extends ConsumerState<_PostingForm> {
  final _formKey = GlobalKey<FormState>();
  late final _company = TextEditingController(text: widget.initial.company);
  late final _position = TextEditingController(text: widget.initial.position);
  late final _url = TextEditingController(text: widget.initial.url);
  late final _location = TextEditingController(text: widget.initial.location);
  late final _memo = TextEditingController(text: widget.initial.memo);
  late JobChannel _channel = widget.initial.channel;
  late EmploymentType? _employmentType = widget.initial.employmentType;
  late DateTime? _deadline = widget.initial.deadline;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_company, _position, _url, _location, _memo]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final draft = PostingDraft(
      company: _company.text,
      position: _position.text,
      url: _url.text,
      channel: _channel,
      deadline: _deadline,
      location: _location.text,
      employmentType: _employmentType,
      memo: _memo.text,
    );
    try {
      final saved = await widget.onSave(draft);
      if (mounted) context.pop(saved);
    } on AppFailure catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  static String? _required(String? v, String name) =>
      (v == null || v.trim().isEmpty) ? '$name을(를) 입력해 주세요.' : null;

  static String? _validUrl(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final uri = Uri.tryParse(v.trim());
    final ok = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    return ok ? null : 'http:// 또는 https://로 시작하는 주소를 넣어 주세요.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _saving
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(onPressed: _save, child: const Text('저장')),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('form-company'),
              controller: _company,
              decoration: const InputDecoration(labelText: '회사명 *'),
              textInputAction: TextInputAction.next,
              validator: (v) => _required(v, '회사명'),
            ),
            TextFormField(
              key: const Key('form-position'),
              controller: _position,
              decoration: const InputDecoration(labelText: '포지션 *'),
              textInputAction: TextInputAction.next,
              validator: (v) => _required(v, '포지션'),
            ),
            TextFormField(
              key: const Key('form-url'),
              controller: _url,
              decoration: const InputDecoration(labelText: '공고 URL'),
              keyboardType: TextInputType.url,
              validator: _validUrl,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<JobChannel>(
              initialValue: _channel,
              decoration: const InputDecoration(labelText: '채널'),
              items: [
                for (final c in JobChannel.values)
                  DropdownMenuItem(value: c, child: Text(c.label)),
              ],
              onChanged: (c) => setState(() => _channel = c ?? _channel),
            ),
            const SizedBox(height: 4),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('마감일'),
              subtitle: Text(
                _deadline == null ? '없음 (상시 채용 등)' : formatDate(_deadline!),
              ),
              onTap: _pickDeadline,
              trailing: _deadline == null
                  ? const Icon(Icons.calendar_today)
                  : IconButton(
                      tooltip: '마감일 지우기',
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _deadline = null),
                    ),
            ),
            TextFormField(
              controller: _location,
              decoration: const InputDecoration(labelText: '근무지'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EmploymentType?>(
              initialValue: _employmentType,
              decoration: const InputDecoration(labelText: '고용형태'),
              items: [
                const DropdownMenuItem(value: null, child: Text('선택 안 함')),
                for (final t in EmploymentType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (t) => setState(() => _employmentType = t),
            ),
            TextFormField(
              controller: _memo,
              decoration: const InputDecoration(labelText: '메모'),
              minLines: 2,
              maxLines: 6,
            ),
          ],
        ),
      ),
    );
  }
}
