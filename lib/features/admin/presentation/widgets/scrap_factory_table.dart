import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../logic/cubits/scrap_analysis_cubit.dart'; // Import ScrapData via Cubit

class ScrapFactoryTable extends StatelessWidget {
  final List<ScrapData> data;
  final String factory;

  const ScrapFactoryTable({
    super.key,
    required this.data,
    required this.factory,
  });

  @override
  Widget build(BuildContext context) {
    final items = data.where((e) => e.factory == factory).toList();

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
