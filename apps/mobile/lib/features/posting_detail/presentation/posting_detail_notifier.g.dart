// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posting_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostingDetailNotifier)
final postingDetailProvider = PostingDetailNotifierFamily._();

final class PostingDetailNotifierProvider
    extends $AsyncNotifierProvider<PostingDetailNotifier, PostingDetail> {
  PostingDetailNotifierProvider._({
    required PostingDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postingDetailNotifierHash();

  @override
  String toString() {
    return r'postingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostingDetailNotifier create() => PostingDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is PostingDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postingDetailNotifierHash() =>
    r'33ab71ed0f2c0a974d86c59d9c4f02f1a56875bc';

final class PostingDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PostingDetailNotifier,
          AsyncValue<PostingDetail>,
          PostingDetail,
          FutureOr<PostingDetail>,
          String
        > {
  PostingDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'postingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostingDetailNotifierProvider call(String postingId) =>
      PostingDetailNotifierProvider._(argument: postingId, from: this);

  @override
  String toString() => r'postingDetailProvider';
}

abstract class _$PostingDetailNotifier extends $AsyncNotifier<PostingDetail> {
  late final _$args = ref.$arg as String;
  String get postingId => _$args;

  FutureOr<PostingDetail> build(String postingId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostingDetail>, PostingDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostingDetail>, PostingDetail>,
              AsyncValue<PostingDetail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
