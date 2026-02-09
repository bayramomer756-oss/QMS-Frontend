// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fire Search Remote DataSource Provider

@ProviderFor(fireSearchRemoteDataSource)
final fireSearchRemoteDataSourceProvider =
    FireSearchRemoteDataSourceProvider._();

/// Fire Search Remote DataSource Provider

final class FireSearchRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          FireSearchRemoteDataSource,
          FireSearchRemoteDataSource,
          FireSearchRemoteDataSource
        >
    with $Provider<FireSearchRemoteDataSource> {
  /// Fire Search Remote DataSource Provider
  FireSearchRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fireSearchRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fireSearchRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<FireSearchRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FireSearchRemoteDataSource create(Ref ref) {
    return fireSearchRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FireSearchRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FireSearchRemoteDataSource>(value),
    );
  }
}

String _$fireSearchRemoteDataSourceHash() =>
    r'b0a9eb36ddb4faa19fbd71b560358bd12bf9260e';

/// Fire Search Repository Provider

@ProviderFor(fireSearchRepository)
final fireSearchRepositoryProvider = FireSearchRepositoryProvider._();

/// Fire Search Repository Provider

final class FireSearchRepositoryProvider
    extends
        $FunctionalProvider<
          IFireSearchRepository,
          IFireSearchRepository,
          IFireSearchRepository
        >
    with $Provider<IFireSearchRepository> {
  /// Fire Search Repository Provider
  FireSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fireSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fireSearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<IFireSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IFireSearchRepository create(Ref ref) {
    return fireSearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IFireSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IFireSearchRepository>(value),
    );
  }
}

String _$fireSearchRepositoryHash() =>
    r'3d69e995420ced831e18c03e6743eba39e648f9c';

/// Search Fire Records UseCase Provider

@ProviderFor(searchFireRecordsUseCase)
final searchFireRecordsUseCaseProvider = SearchFireRecordsUseCaseProvider._();

/// Search Fire Records UseCase Provider

final class SearchFireRecordsUseCaseProvider
    extends
        $FunctionalProvider<
          SearchFireRecordsUseCase,
          SearchFireRecordsUseCase,
          SearchFireRecordsUseCase
        >
    with $Provider<SearchFireRecordsUseCase> {
  /// Search Fire Records UseCase Provider
  SearchFireRecordsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFireRecordsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFireRecordsUseCaseHash();

  @$internal
  @override
  $ProviderElement<SearchFireRecordsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchFireRecordsUseCase create(Ref ref) {
    return searchFireRecordsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFireRecordsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFireRecordsUseCase>(value),
    );
  }
}

String _$searchFireRecordsUseCaseHash() =>
    r'4335d678a58f0e2712c884c165bc185c0af3a0cd';

/// Fire Search State Provider
/// Fire arama sonuçlarını ve state'ini yönetir

@ProviderFor(FireSearchState)
final fireSearchStateProvider = FireSearchStateProvider._();

/// Fire Search State Provider
/// Fire arama sonuçlarını ve state'ini yönetir
final class FireSearchStateProvider
    extends $AsyncNotifierProvider<FireSearchState, List<FireSearchResult>> {
  /// Fire Search State Provider
  /// Fire arama sonuçlarını ve state'ini yönetir
  FireSearchStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fireSearchStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fireSearchStateHash();

  @$internal
  @override
  FireSearchState create() => FireSearchState();
}

String _$fireSearchStateHash() => r'2a6bfb313ed9f649a2d4dab6d1092016765ef54d';

/// Fire Search State Provider
/// Fire arama sonuçlarını ve state'ini yönetir

abstract class _$FireSearchState
    extends $AsyncNotifier<List<FireSearchResult>> {
  FutureOr<List<FireSearchResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FireSearchResult>>, List<FireSearchResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FireSearchResult>>,
                List<FireSearchResult>
              >,
              AsyncValue<List<FireSearchResult>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
