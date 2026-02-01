import 'package:flutter/material.dart';

// import 'package:excel/excel.dart' as excel_pkg;
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
// import 'dart:io';
import '../../../core/constants/app_colors.dart';

// Veri Modeli
class ScrapData {
  final String factory; // D2, D3, FRENBU
  final String productType; // Disk, Kampana, Porya
  final String productCode;
  final int productionQty;
  final int scrapQty;
  final String defectReason; // Hata nedeni (Frenbu için)

  ScrapData({
    required this.factory,
    required this.productType,
    required this.productCode,
    required this.productionQty,
    required this.scrapQty,
    this.defectReason = '',
  });

  double get rate => productionQty > 0 ? (scrapQty / productionQty) * 100 : 0;
}

class ScrapAnalysisTab extends StatefulWidget {
  const ScrapAnalysisTab({super.key});

  @override
  State<ScrapAnalysisTab> createState() => _ScrapAnalysisTabState();
}

class _ScrapAnalysisTabState extends State<ScrapAnalysisTab>
    with SingleTickerProviderStateMixin {
  late TabController _factoryTabController;

  // Mock Data (Excel'den gelmiş gibi)
  List<ScrapData> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _factoryTabController = TabController(length: 3, vsync: this);
    _loadMockData(); // Başlangıçta örnek veri göster
  }

  void _loadMockData() {
    // Görsellerdeki verilere benzer mock veriler
    _data = [
      // FRENBU
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '4210010',
        productionQty: 254,
        scrapQty: 2,
        defectReason: 'Elmas Kırması',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Kampana',
        productCode: '5025920',
        productionQty: 40,
        scrapQty: 1,
        defectReason: 'Darbeye Bağlı Kırık',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6310051',
        productionQty: 128,
        scrapQty: 1,
        defectReason: 'Malzeme Kaldırmış',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6310481',
        productionQty: 59,
        scrapQty: 4,
        defectReason: 'Elmas Kırması',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6312011',
        productionQty: 456,
        scrapQty: 3,
        defectReason: 'Robot Sensör Hatası',
      ),
      // D2 DIŞ FİRE
      ScrapData(
        factory: 'D2',
        productType: 'Disk',
        productCode: '4810300',
        productionQty: 99,
        scrapQty: 2,
      ),
      ScrapData(
        factory: 'D2',
        productType: 'Disk',
        productCode: '6310481',
        productionQty: 59,
        scrapQty: 1,
      ),
      ScrapData(
        factory: 'D2',
        productType: 'Porya',
        productCode: '6340050',
        productionQty: 126,
        scrapQty: 1,
      ),
      // D3 DIŞ FİRE
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '1810360',
        productionQty: 27,
        scrapQty: 4,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '4210010',
        productionQty: 254,
        scrapQty: 10,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '4210020',
        productionQty: 268,
        scrapQty: 11,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Kampana',
        productCode: '5025940',
        productionQty: 112,
        scrapQty: 1,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '6312011',
        productionQty: 456,
        scrapQty: 29,
      ),
    ];
    setState(() {});
  }

  Future<void> _importExcel() async {
    // Show copy-paste dialog
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Excel\'den Yapıştır',
            style: TextStyle(color: AppColors.textMain),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Excel verilerini kopyalayıp (Ctrl+C) aşağıdaki alana yapıştırın (Ctrl+V).\nFormat: Fabrika | Ürün Tipi | Ürün Kodu | Üretim | Fire | Hata Nedeni (Opsiyonel)',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 10,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'FRENBU\tDisk\t4210010\t254\t2\tElmas Kırması...',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.duzceGreen,
              ),
              child: const Text('Verileri İşle'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      try {
        setState(() => _isLoading = true);

        // Parse Logic
        final List<ScrapData> newItems = [];
        final lines = result.split('\n');

        for (var line in lines) {
          if (line.trim().isEmpty) continue;
          final parts = line.split('\t');
          if (parts.length >= 5) {
            // En az 5 kolon: Fabrika, Tip, Kod, Üretim, Fire
            newItems.add(
              ScrapData(
                factory: parts[0].trim(),
                productType: parts[1].trim(),
                productCode: parts[2].trim(),
                productionQty: int.tryParse(parts[3].replaceAll('.', '')) ?? 0,
                scrapQty: int.tryParse(parts[4].replaceAll('.', '')) ?? 0,
                defectReason: parts.length > 5 ? parts[5].trim() : '',
              ),
            );
          }
        }

        if (newItems.isNotEmpty) {
          setState(() {
            _data = newItems;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${newItems.length} kayıt başarıyla işlendi'),
              backgroundColor: AppColors.duzceGreen,
            ),
          );
        } else {
          throw Exception('Formatı uygun veri bulunamadı');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.error),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header & Actions
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Fire Oranlama Analizi',
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Günlük üretim ve fire verileri',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _importExcel,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(LucideIcons.upload, size: 18),
                label: const Text('Excel Yükle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.duzceGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toplam Özet Kartları
                _buildSummaryCards(),
                const SizedBox(height: 24),

                // Pasta Grafik
                _buildPieChartSection(),
                const SizedBox(height: 24),

                // Fabrika Detay Tabloları
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _factoryTabController,
                        labelColor: AppColors.textMain,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primary,
                        tabs: const [
                          Tab(text: 'FRENBU'),
                          Tab(text: 'D2 FABRİKA'),
                          Tab(text: 'D3 FABRİKA'),
                        ],
                      ),
                      SizedBox(
                        height: 500, // Sabit yükseklik veya dynamic calculation
                        child: TabBarView(
                          controller: _factoryTabController,
                          children: [
                            _buildFactoryTable('FRENBU'),
                            _buildFactoryTable('D2'),
                            _buildFactoryTable('D3'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    int totalProd = _data.fold(0, (sum, item) => sum + item.productionQty);
    int totalScrap = _data.fold(0, (sum, item) => sum + item.scrapQty);
    double avgRate = totalProd > 0 ? (totalScrap / totalProd) * 100 : 0;

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Toplam Üretim',
            '$totalProd',
            LucideIcons.package,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Toplam Fire',
            '$totalScrap',
            LucideIcons.trash2,
            AppColors.error,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Genel Fire Oranı',
            '%${avgRate.toStringAsFixed(2)}',
            LucideIcons.percent,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection() {
    // Fabrika bazlı oran hesapla
    Map<String, double> factoryRates = {};
    for (var f in ['D2', 'D3', 'FRENBU']) {
      final items = _data.where((e) => e.factory == f).toList();
      int p = items.fold(0, (sum, e) => sum + e.productionQty);
      int s = items.fold(0, (sum, e) => sum + e.scrapQty);
      factoryRates[f] = p > 0 ? (s / p) * 100 : 0;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          const Text(
            'Fabrikaların Günlük Fire Oranları',
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: factoryRates['D2'] ?? 0,
                          title:
                              'D2\n%${(factoryRates['D2'] ?? 0).toStringAsFixed(2)}',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.orange,
                          value: factoryRates['D3'] ?? 0,
                          title:
                              'D3\n%${(factoryRates['D3'] ?? 0).toStringAsFixed(2)}',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.grey,
                          value: factoryRates['FRENBU'] ?? 0,
                          title:
                              'FRENBU\n%${(factoryRates['FRENBU'] ?? 0).toStringAsFixed(2)}',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Legend
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('D2 Fabrika', Colors.blue),
                    const SizedBox(height: 8),
                    _buildLegendItem('D3 Fabrika', Colors.orange),
                    const SizedBox(height: 8),
                    _buildLegendItem('FRENBU', Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFactoryTable(String factory) {
    final items = _data.where((e) => e.factory == factory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$factory Detay Raporu',
            style: const TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: AppColors.border, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(1.5), // Ürün Türü
              1: FlexColumnWidth(2), // Ürün Kodu
              2: FlexColumnWidth(1.5), // Üretim
              3: FlexColumnWidth(1.5), // Fire
              4: FlexColumnWidth(1.5), // Oran
            },
            children: [
              // Header
              TableRow(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Ürün Türü',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Ürün Kodu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Üretim',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Fire Adet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Oran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ],
              ),
              // Data
              ...items.map((item) {
                final isHigh = item.rate > 2.0;
                return TableRow(
                  decoration: BoxDecoration(
                    color: isHigh
                        ? AppColors.error.withValues(alpha: 0.1)
                        : null,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item.productType,
                        style: const TextStyle(color: AppColors.textMain),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item.productCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${item.productionQty}',
                        style: const TextStyle(color: AppColors.textMain),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${item.scrapQty}',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '%${item.rate.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: isHigh ? AppColors.error : AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),

          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Bu fabrika için veri bulunamadı.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

          // Frenbu için Hata Dağılımı (Ekstra Tablo)
          if (factory == 'FRENBU' && items.isNotEmpty) ...[
            const SizedBox(height: 32),
            const Text(
              'HATA DAĞILIMI',
              style: TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _buildDefectTable(items),
          ],
        ],
      ),
    );
  }

  Widget _buildDefectTable(List<ScrapData> items) {
    // Hata nedenlerine göre grupla
    Map<String, int> defectCounts = {};
    for (var item in items) {
      if (item.defectReason.isNotEmpty) {
        defectCounts[item.defectReason] =
            (defectCounts[item.defectReason] ?? 0) + item.scrapQty;
      }
    }

    return Table(
      border: TableBorder.all(color: AppColors.border, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2)),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Hata Tanımı',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Toplam Fire',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ),
          ],
        ),
        ...defectCounts.entries.map((entry) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  entry.key,
                  style: const TextStyle(color: AppColors.textMain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
