import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ReworkAnalysisCard extends StatelessWidget {
  const ReworkAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ürün Ayrımı
    final productData = [
      {'bg': 'Disk', 'qty': 15},
      {'bg': 'Kampana', 'qty': 8},
      {'bg': 'Poyra', 'qty': 4},
    ];
    // İşlem Ayrımı
    final processData = [
      {'proc': 'Yüzey Temizleme', 'qty': 12},
      {'proc': 'Çapak Alma', 'qty': 10},
      {'proc': 'Boyama', 'qty': 5},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ürün Bazlı Ayrım',
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: productData
                .map(
                  (e) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${e['qty']}',
                            style: const TextStyle(
                              color: AppColors.reworkOrange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            e['bg'] as String,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'İşlem Bazlı Ayrım',
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...processData.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      e['proc'] as String,
                      style: const TextStyle(color: AppColors.textMain),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  Text(
                    '${e['qty']}',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
