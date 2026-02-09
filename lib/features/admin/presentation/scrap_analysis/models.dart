class ProductionEntry {
  final String productCode;
  final String factoryType; // 'D2' or 'D3'
  final int quantity;

  ProductionEntry({
    required this.productCode,
    required this.factoryType,
    required this.quantity,
  });

  @override
  String toString() =>
      'ProductionEntry(code: $productCode, factory: $factoryType, qty: $quantity)';
}

class AnalysisResult {
  final int d2Production;
  final int d3Production;
  final int frenbuCount;
  final List<ProductionEntry> nonScrapItems;

  AnalysisResult({
    this.d2Production = 0,
    this.d3Production = 0,
    this.frenbuCount = 0,
    this.nonScrapItems = const [],
  });

  // Empty initial state
  factory AnalysisResult.empty() {
    return AnalysisResult();
  }
}

// Simplified definition of Fire Data for Isolate transfer
class FireAnalysisData {
  final String productCode;
  final String defectCode;
  final String batchNo;

  FireAnalysisData({
    required this.productCode,
    required this.defectCode, // 'hataKodu'
    required this.batchNo, // 'sarjNo'
  });
}
