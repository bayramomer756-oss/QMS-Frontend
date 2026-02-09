import 'package:dio/dio.dart';
import '../models/product_dto.dart';

/// Product Remote DataSource
/// Backend API'den ürün verilerini çeker
class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource(this._dio);

  // Mock data için flag (backend hazır olunca false yapın)
  static const bool useMockData = true;

  /// Ürün arama - query parametresi ile filtreleme
  ///
  /// [query] arama terimi (ürün kodu veya adı)
  /// Returns list of ProductDto
  ///
  /// Throws [DioException] on network errors
  Future<List<ProductDto>> searchProducts(String query) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockProducts = [
        const ProductDto(
          urunKodu: '6312011',
          urunAdi: 'SAF B9',
          urunTuru: 'Dövme',
        ),
        const ProductDto(
          urunKodu: '6312012',
          urunAdi: 'Şanzıman Dişlisi',
          urunTuru: 'Talaşlı İmalat',
        ),
        const ProductDto(
          urunKodu: '6312013',
          urunAdi: 'Aks Mili',
          urunTuru: 'Dövme',
        ),
        const ProductDto(
          urunKodu: '6312014',
          urunAdi: 'Piston Kolu',
          urunTuru: 'Montaj',
        ),
        const ProductDto(
          urunKodu: '6312015',
          urunAdi: 'Fren Diski',
          urunTuru: 'Döküm',
        ),
      ];

      if (query.isEmpty) return mockProducts;

      final lowerQuery = query.toLowerCase();
      return mockProducts.where((p) {
        return p.urunKodu.toLowerCase().contains(lowerQuery) ||
            p.urunAdi.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    try {
      final response = await _dio.get(
        '/api/lookup/urunler',
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Result wrapper pattern kontrolü
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productList = data['data'] as List<dynamic>;
          return productList
              .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          // API başarısız response döndü
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Ürünler getirilemedi',
            response: response,
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/lookup/urunler'),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
