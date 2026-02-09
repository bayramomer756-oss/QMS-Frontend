import '../../domain/entities/product.dart';

/// Product DTO - Data Transfer Object
/// API response'larını map etmek için kullanılır
class ProductDto extends Product {
  const ProductDto({
    required super.urunKodu,
    required super.urunAdi,
    required super.urunTuru,
  });

  /// JSON'dan ProductDto oluştur
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      urunKodu: json['urunKodu'] as String,
      urunAdi: json['urunAdi'] as String,
      urunTuru: json['urunTuru'] as String,
    );
  }

  /// ProductDto'yu JSON'a dönüştür
  Map<String, dynamic> toJson() {
    return {'urunKodu': urunKodu, 'urunAdi': urunAdi, 'urunTuru': urunTuru};
  }

  /// DTO'dan Entity'ye dönüşüm
  Product toEntity() {
    return Product(urunKodu: urunKodu, urunAdi: urunAdi, urunTuru: urunTuru);
  }
}
