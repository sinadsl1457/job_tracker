// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postings_filter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostingsFilterNotifier)
final postingsFilterProvider = PostingsFilterNotifierProvider._();

final class PostingsFilterNotifierProvider
    extends $NotifierProvider<PostingsFilterNotifier, PostingsFilter> {
  PostingsFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postingsFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postingsFilterNotifierHash();

  @$internal
  @override
  PostingsFilterNotifier create() => PostingsFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostingsFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostingsFilter>(value),
    );
  }
}

String _$postingsFilterNotifierHash() =>
    r'8e9dbcdbf4c10d556531527fc45e8ff534829a69';

abstract class _$PostingsFilterNotifier extends $Notifier<PostingsFilter> {
  PostingsFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PostingsFilter, PostingsFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostingsFilter, PostingsFilter>,
              PostingsFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
