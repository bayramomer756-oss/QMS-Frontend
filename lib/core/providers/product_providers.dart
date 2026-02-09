import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/entities/product.dart';
import '../domain/repositories/i_product_repository.dart';
import '../domain/usecases/search_products_usecase.dart';
import '../network/dio_client.dart';

part 'product_providers.g.dart';

/// Product Remote DataSource Provider
@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ProductRemoteDataSource(dio);
}

/// Product Repository Provider
@riverpod
IProductRepository productRepository(Ref ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
}

/// Search Products UseCase Provider
@riverpod
SearchProductsUseCase searchProductsUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return SearchProductsUseCase(repository);
}

/// Product Search State Provider
/// Ürün arama state'ini yönetir
@riverpod
class ProductSearch extends _$ProductSearch {
  @override
  FutureOr<List<Product>> build() {
    return [];
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().length < 2) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    final useCase = ref.read(searchProductsUseCaseProvider);

    state = await AsyncValue.guard(() async {
      final products = await useCase.call(query);

      // Sort: codes starting with "4" go to bottom
      products.sort((a, b) {
        final aStartsWith4 = a.urunKodu.startsWith('4');
        final bStartsWith4 = b.urunKodu.startsWith('4');

        if (aStartsWith4 && !bStartsWith4) return 1; // a goes after b
        if (!aStartsWith4 && bStartsWith4) return -1; // a goes before b
        return 0; // maintain original order
      });

      return products;
    });
  }

  /// State'i temizle
  void clear() {
    state = const AsyncValue.data([]);
  }
}
