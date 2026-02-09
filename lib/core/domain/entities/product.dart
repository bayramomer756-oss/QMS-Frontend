/// Product entity - Pure business model
/// Ürün bilgilerini temsil eden domain entity
class Product {
  final String urunKodu;
  final String urunAdi;
  final String urunTuru;

  const Product({
    required this.urunKodu,
    required this.urunAdi,
    required this.urunTuru,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.urunKodu == urunKodu &&
        other.urunAdi == urunAdi &&
        other.urunTuru == urunTuru;
  }

  @override
  int get hashCode => urunKodu.hashCode ^ urunAdi.hashCode ^ urunTuru.hashCode;

  @override
  String toString() =>
      'Product(urunKodu: $urunKodu, urunAdi: $urunAdi, urunTuru: $urunTuru)';
}
