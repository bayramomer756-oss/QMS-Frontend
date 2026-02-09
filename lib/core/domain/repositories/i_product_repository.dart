import '../entities/product.dart';

/// Product Repository Interface
/// Product data operations için contract tanımı
abstract class IProductRepository {
  /// Ürün arama
  ///
  /// [query] arama terimi
  /// Returns list of Product entities
  Future<List<Product>> searchProducts(String query);
}
