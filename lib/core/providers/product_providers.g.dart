// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Product Remote DataSource Provider

@ProviderFor(productRemoteDataSource)
final productRemoteDataSourceProvider = ProductRemoteDataSourceProvider._();

/// Product Remote DataSource Provider

final class ProductRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProductRemoteDataSource,
          ProductRemoteDataSource,
          ProductRemoteDataSource
        >
    with $Provider<ProductRemoteDataSource> {
  /// Product Remote DataSource Provider
  ProductRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProductRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRemoteDataSource create(Ref ref) {
    return productRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRemoteDataSource>(value),
    );
  }
}

String _$productRemoteDataSourceHash() =>
    r'867510265dffbe64249ac13677e0bb9929888945';

/// Product Repository Provider

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

/// Product Repository Provider

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          IProductRepository,
          IProductRepository,
          IProductRepository
        >
    with $Provider<IProductRepository> {
  /// Product Repository Provider
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<IProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'81ef1bbea6bdf7232fd491b8c108b170a7492da0';

/// Search Products UseCase Provider

@ProviderFor(searchProductsUseCase)
final searchProductsUseCaseProvider = SearchProductsUseCaseProvider._();

/// Search Products UseCase Provider

final class SearchProductsUseCaseProvider
    extends
        $FunctionalProvider<
          SearchProductsUseCase,
          SearchProductsUseCase,
          SearchProductsUseCase
        >
    with $Provider<SearchProductsUseCase> {
  /// Search Products UseCase Provider
  SearchProductsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProductsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchProductsUseCaseHash();

  @$internal
  @override
  $ProviderElement<SearchProductsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchProductsUseCase create(Ref ref) {
    return searchProductsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchProductsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchProductsUseCase>(value),
    );
  }
}

String _$searchProductsUseCaseHash() =>
    r'a23bcf5674848fcbeee204de4b245e63b677c60a';

/// Product Search State Provider
/// Ürün arama state'ini yönetir

@ProviderFor(ProductSearch)
final productSearchProvider = ProductSearchProvider._();

/// Product Search State Provider
/// Ürün arama state'ini yönetir
final class ProductSearchProvider
    extends $AsyncNotifierProvider<ProductSearch, List<Product>> {
  /// Product Search State Provider
  /// Ürün arama state'ini yönetir
  ProductSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productSearchHash();

  @$internal
  @override
  ProductSearch create() => ProductSearch();
}

String _$productSearchHash() => r'088666ae315d562a1d7c4f67bab78ddb7b2959c1';

/// Product Search State Provider
/// Ürün arama state'ini yönetir

abstract class _$ProductSearch extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
