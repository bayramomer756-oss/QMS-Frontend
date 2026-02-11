import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

class ScrapAnalysisState {
  final bool isLoading;
  final String? error;
  final ScrapDashboardData? dashboardData;

  ScrapAnalysisState({this.isLoading = false, this.error, this.dashboardData});

  ScrapAnalysisState copyWith({
    bool? isLoading,
    String? error,
    ScrapDashboardData? dashboardData,
  }) {
    return ScrapAnalysisState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }
}

class ScrapAnalysisNotifier extends Notifier<ScrapAnalysisState> {
  @override
  ScrapAnalysisState build() {
    return ScrapAnalysisState();
  }

  Future<void> parseExcel(List<int> bytes) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final excel = Excel.decodeBytes(bytes);
      final List<ScrapUploadItem> productionItems = [];

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        for (var row in sheet.rows) {
          if (row.isEmpty) continue;

          // Header Check (skip row if contains 'kod')
          final firstCellVal = row[0]?.value?.toString() ?? '';
          if (firstCellVal.toLowerCase().contains('tarih') ||
              firstCellVal.toLowerCase().contains('kod')) {
            continue;
          }

          if (row.length < 4) continue; // Col A, B, C, D (Index 0, 1, 2, 3)

          // 0: Date (Optional, can extract if needed)
          // 1: Product Code
          // 2: Factory (D2, D3)
          // 3: Quantity

          final productCode = row[1]?.value?.toString().trim() ?? '';
          final factory = row[2]?.value?.toString().trim().toUpperCase() ?? '';
          final quantityCell = row[3];

          int quantity = _parseQuantity(quantityCell);

          if (productCode.isNotEmpty) {
            productionItems.add(
              ScrapUploadItem(
                productCode: productCode,
                factory: factory,
                quantity: quantity,
              ),
            );
          }
        }
      }

      // Generate Dashboard Data
      // Use the date from the first batch or current date if not found
      DateTime initialDate = DateTime.now();
      if (productionItems.isNotEmpty && productionItems.first.date != null) {
        initialDate = productionItems.first.date!;
      }

      final dashboardData = _generateDashboardData(
        productionItems,
        initialDate,
      );
      state = state.copyWith(isLoading: false, dashboardData: dashboardData);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Analiz hatası: $e');
    }
  }

  int _parseQuantity(dynamic cell) {
    if (cell == null || cell.value == null) return 0;
    final val = cell.value;

    dynamic dVal = val;
    if (dVal is int) return dVal;
    if (dVal is double) return dVal.toInt();

    return int.tryParse(dVal.toString()) ?? 0;
  }

  ScrapDashboardData _generateDashboardData(
    List<ScrapUploadItem> productionItems,
    DateTime date,
  ) {
    // 1. MOCK SCRAP DATA (Simulating 'Fire Kayıtları' from database)
    // In real app, this would be fetched from repository based on Date Range
    // Structure: Defect Code, Product Code, Scrap Qty
    final List<Map<String, dynamic>> mockScrapData = [
      // Frenbu Scraps (Starts with T, TI, etc - usually TI)
      {'defect': 'Tİ-01', 'product': '1310130', 'qty': 1},
      {'defect': 'Tİ-02', 'product': '4210020', 'qty': 14},
      {'defect': 'Tİ-01', 'product': '5623060', 'qty': 1},
      {'defect': 'Tİ-03', 'product': '6312011', 'qty': 2},
      {'defect': 'Tİ-04', 'product': '6325360', 'qty': 1},
      // D2 Scraps (Starts with D)
      {'defect': 'D-01', 'product': '1820910', 'qty': 7},
      {'defect': 'D-02', 'product': '2621090', 'qty': 5},
      {'defect': 'D-03', 'product': '3921980', 'qty': 2},
      {'defect': 'D-01', 'product': '5623060', 'qty': 1},
      {'defect': 'D-05', 'product': '6340051', 'qty': 6},
      // D3 Scraps (Starts with D)
      {'defect': 'D-01', 'product': '1310130', 'qty': 7},
      {'defect': 'D-02', 'product': '4210010', 'qty': 7},
      {'defect': 'D-03', 'product': '4210020', 'qty': 11},
      {'defect': 'D-04', 'product': '4810310', 'qty': 1},

      // Some mock defects for distribution matrix
      {'defect': '1.Yön Bağlama Hatası', 'product': '5623060', 'qty': 1},
      {'defect': 'Darbeye Bağlı Kırık', 'product': '1310130', 'qty': 1},
      {'defect': 'Delik Kaçıklığı', 'product': '4210020', 'qty': 16},
    ];

    // 2. Aggregate Data
    final frenbuTable = <ScrapTableItem>[];
    final d2Table = <ScrapTableItem>[];
    final d3Table = <ScrapTableItem>[];
    final d2Clean = <ProductionEntry>[];
    final d3Clean = <ProductionEntry>[];

    int totalFrenbuProd = 0;
    int totalD2Scrap = 0;
    int totalD3Scrap = 0;
    int totalFrenbuScrap = 0;

    int totalD2Turned = 0;
    int totalD3Turned = 0;

    // Filter scraps by selected date (Mocking logic: if date is selected, we might want to vary data)
    // For now, we use static mock data but in real scenario, we would query DB with this date.
    final selectedScraps = mockScrapData;

    // In a real implementation:
    // final selectedScraps = await repository.getScrapsByDate(date);

    for (var item in productionItems) {
      // Find scraps for this product
      final productScraps = selectedScraps
          .where((s) => s['product'] == item.productCode)
          .toList();

      int dScrapQty = 0;
      int tiScrapQty = 0;

      for (var s in productScraps) {
        final defectCode = s['defect'] as String;
        final qty = s['qty'] as int;

        if (defectCode.startsWith('D')) {
          dScrapQty += qty;
        } else if (defectCode.startsWith('Tİ') ||
            defectCode.startsWith('TI') ||
            !defectCode.startsWith('D')) {
          // Treating non-D as Frenbu (Tİ) based on user prompt logic
          tiScrapQty += qty;
        }
      }

      String type = _getProductType(item.productCode);

      // FRENBU TABLE (TI Scraps)
      if (tiScrapQty > 0 || item.quantity > 0) {
        // Only add if there is production or scrap?
        if (item.quantity > 0) {
          frenbuTable.add(
            ScrapTableItem(
              productType: type,
              productCode: item.productCode,
              productionQty: item.quantity,
              scrapQty: tiScrapQty,
              scrapRate: item.quantity > 0
                  ? (tiScrapQty / item.quantity) * 100
                  : 0,
            ),
          );
          totalFrenbuProd += item.quantity;
          totalFrenbuScrap += tiScrapQty;
        }
      }

      // FOUNDRY TABLES (D Scraps)
      // Logic: If factory is D2 -> D2 Table, if D3 -> D3 Table.
      // But user dashboard shows "D2 DIŞ FİRE" and "D3 DIŞ FİRE".
      // And the uploaded excel has a "Factory" column.

      if (item.factory == 'D2') {
        totalD2Turned += item.quantity;
        if (dScrapQty > 0) {
          d2Table.add(
            ScrapTableItem(
              productType: type,
              productCode: item.productCode,
              productionQty: item.quantity,
              scrapQty: dScrapQty,
              scrapRate: item.quantity > 0
                  ? (dScrapQty / item.quantity) * 100
                  : 0,
            ),
          );
          totalD2Scrap += dScrapQty;
        } else {
          d2Clean.add(
            ProductionEntry(
              productCode: item.productCode,
              factoryType: 'D2',
              quantity: item.quantity,
            ),
          );
        }
      } else if (item.factory == 'D3') {
        totalD3Turned += item.quantity;
        if (dScrapQty > 0) {
          d3Table.add(
            ScrapTableItem(
              productType: type,
              productCode: item.productCode,
              productionQty: item.quantity,
              scrapQty: dScrapQty,
              scrapRate: item.quantity > 0
                  ? (dScrapQty / item.quantity) * 100
                  : 0,
            ),
          );
          totalD3Scrap += dScrapQty;
        } else {
          d3Clean.add(
            ProductionEntry(
              productCode: item.productCode,
              factoryType: 'D3',
              quantity: item.quantity,
            ),
          );
        }
      }
    }

    // Sort tables by Scrap Rate desc
    frenbuTable.sort((a, b) => b.scrapRate.compareTo(a.scrapRate));
    d2Table.sort((a, b) => b.scrapRate.compareTo(a.scrapRate));
    d3Table.sort((a, b) => b.scrapRate.compareTo(a.scrapRate));

    return ScrapDashboardData(
      date: DateTime.now(), // Should rely on Excel date column if available
      totalFrenbuProduction: totalFrenbuProd,
      summary: FactorySummary(
        d2ScrapDto: totalD2Scrap,
        d2Turned: totalD2Turned,
        d2Rate: totalD2Turned > 0 ? (totalD2Scrap / totalD2Turned) * 100 : 0,
        d3ScrapDto: totalD3Scrap,
        d3Turned: totalD3Turned,
        d3Rate: totalD3Turned > 0 ? (totalD3Scrap / totalD3Turned) * 100 : 0,
        frenbuScrapDto: totalFrenbuScrap,
        frenbuTurned: totalFrenbuProd,
        frenbuRate: totalFrenbuProd > 0
            ? (totalFrenbuScrap / totalFrenbuProd) * 100
            : 0,
      ),
      dailyScrapRates: [
        FactoryDailyScrap(
          'D2',
          totalD2Turned > 0 ? (totalD2Scrap / totalD2Turned) * 100 : 0,
        ),
        FactoryDailyScrap(
          'D3',
          totalD3Turned > 0 ? (totalD3Scrap / totalD3Turned) * 100 : 0,
        ),
        FactoryDailyScrap(
          'FRENBU',
          totalFrenbuProd > 0 ? (totalFrenbuScrap / totalFrenbuProd) * 100 : 0,
        ),
      ],
      frenbuTable: frenbuTable,
      frenbuDefectDistribution: _generateMockDistribution(), // Mock for now
      d2Table: d2Table,
      d3Table: d3Table,
      d2CleanProducts: d2Clean,
      d3CleanProducts: d3Clean,
    );
  }

  String _getProductType(String code) {
    if (code.startsWith('1')) return 'Disk';
    if (code.startsWith('4')) return 'Disk';
    if (code.startsWith('5')) return 'Kampana';
    if (code.startsWith('6')) return 'Kampana';
    if (code.startsWith('8')) return 'Kampana';
    if (code.startsWith('2')) return 'Kampana';
    if (code.startsWith('3')) return 'Kampana';
    if (code.startsWith('8')) return 'Kampana';
    if (code.startsWith('634')) return 'Porya';
    return 'Kampana'; // Default fallback
  }

  List<DefectDistributionItem> _generateMockDistribution() {
    return [
      DefectDistributionItem(
        defectName: '1.Yön Bağlama Hatası',
        drumScrap: 1,
        total: 1,
        rate: 0.03,
      ),
      DefectDistributionItem(
        defectName: 'Darbeye Bağlı Kırık',
        diskScrap: 1,
        total: 1,
        rate: 0.03,
      ),
      DefectDistributionItem(
        defectName: 'Delik Kaçıklığı',
        diskScrap: 12,
        drumScrap: 4,
        total: 16,
        rate: 0.54,
      ),
      DefectDistributionItem(
        defectName: 'Elmas Kırması',
        diskScrap: 1,
        drumScrap: 2,
        total: 3,
        rate: 0.10,
      ),
      DefectDistributionItem(
        defectName: 'Eşmerkezlilik Hatası',
        diskScrap: 2,
        hubScrap: 1,
        total: 3,
        rate: 0.10,
      ),
    ];
  }

  void reset() {
    state = ScrapAnalysisState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final scrapAnalysisProvider =
    NotifierProvider<ScrapAnalysisNotifier, ScrapAnalysisState>(
      ScrapAnalysisNotifier.new,
    );
