// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posting_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostingFormNotifier)
final postingFormProvider = PostingFormNotifierFamily._();

final class PostingFormNotifierProvider
    extends $AsyncNotifierProvider<PostingFormNotifier, PostingDraft> {
  PostingFormNotifierProvider._({
    required PostingFormNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'postingFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postingFormNotifierHash();

  @override
  String toString() {
    return r'postingFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostingFormNotifier create() => PostingFormNotifier();

  @override
  bool operator ==(Object other) {
    return other is PostingFormNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postingFormNotifierHash() =>
    r'4a4a75e11876920910eb366bd028e73f8e5b2659';

final class PostingFormNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PostingFormNotifier,
          AsyncValue<PostingDraft>,
          PostingDraft,
          FutureOr<PostingDraft>,
          String?
        > {
  PostingFormNotifierFamily._()
    : super(
        retry: null,
        name: r'postingFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostingFormNotifierProvider call(String? postingId) =>
      PostingFormNotifierProvider._(argument: postingId, from: this);

  @override
  String toString() => r'postingFormProvider';
}

abstract class _$PostingFormNotifier extends $AsyncNotifier<PostingDraft> {
  late final _$args = ref.$arg as String?;
  String? get postingId => _$args;

  FutureOr<PostingDraft> build(String? postingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostingDraft>, PostingDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostingDraft>, PostingDraft>,
              AsyncValue<PostingDraft>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
