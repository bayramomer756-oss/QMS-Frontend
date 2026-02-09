import '../entities/product.dart';
import '../repositories/i_product_repository.dart';

/// Search Products UseCase
/// Ürün arama business logic'ini içerir
class SearchProductsUseCase {
  final IProductRepository _repository;

  SearchProductsUseCase(this._repository);

  /// Ürün arama işlemini gerçekleştirir
  ///
  /// [query] arama terimi
  /// Minimum 2 karakter gereklidir
  ///
  /// Returns list of Product entities
  Future<List<Product>> call(String query) async {
    // Minimum karakter kontrolü
    if (query.trim().length < 2) {
      return [];
    }

    return await _repository.searchProducts(query.trim());
  }
}
