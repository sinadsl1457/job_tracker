// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posting_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postingRepository)
final postingRepositoryProvider = PostingRepositoryProvider._();

final class PostingRepositoryProvider
    extends
        $FunctionalProvider<
          PostingRepository,
          PostingRepository,
          PostingRepository
        >
    with $Provider<PostingRepository> {
  PostingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postingRepositoryHash();

  @$internal
  @override
  $ProviderElement<PostingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PostingRepository create(Ref ref) {
    return postingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostingRepository>(value),
    );
  }
}

String _$postingRepositoryHash() => r'e340b0040a2a78fb5e099fbf790d933ddc9082d3';

/// 내 공고 전체. 개인 데이터라 많아야 수백 개 → 한 번에 받아 앱에서 거르고 정렬한다.

@ProviderFor(postings)
final postingsProvider = PostingsProvider._();

/// 내 공고 전체. 개인 데이터라 많아야 수백 개 → 한 번에 받아 앱에서 거르고 정렬한다.

final class PostingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobPosting>>,
          List<JobPosting>,
          FutureOr<List<JobPosting>>
        >
    with $FutureModifier<List<JobPosting>>, $FutureProvider<List<JobPosting>> {
  /// 내 공고 전체. 개인 데이터라 많아야 수백 개 → 한 번에 받아 앱에서 거르고 정렬한다.
  PostingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postingsHash();

  @$internal
  @override
  $FutureProviderElement<List<JobPosting>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JobPosting>> create(Ref ref) {
    return postings(ref);
  }
}

String _$postingsHash() => r'56bdf014e2d097a6944f469655f676967c47b39c';

/// 내 모든 단계 이력(통계용).

@ProviderFor(allStageEvents)
final allStageEventsProvider = AllStageEventsProvider._();

/// 내 모든 단계 이력(통계용).

final class AllStageEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StageEvent>>,
          List<StageEvent>,
          FutureOr<List<StageEvent>>
        >
    with $FutureModifier<List<StageEvent>>, $FutureProvider<List<StageEvent>> {
  /// 내 모든 단계 이력(통계용).
  AllStageEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allStageEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allStageEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<StageEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StageEvent>> create(Ref ref) {
    return allStageEvents(ref);
  }
}

String _$allStageEventsHash() => r'028b88ffc67f58340cfe06749aab392f28d152b4';
