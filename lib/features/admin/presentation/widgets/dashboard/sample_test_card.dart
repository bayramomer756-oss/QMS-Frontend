import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class SampleTestFormCard extends StatelessWidget {
  const SampleTestFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock sample/test form data
    final sampleData = [
      {
        'product': 'P001 - Fren Diski',
        'testDate': '01.02.2026',
        'result': 'BAŞARILI',
        'tester': 'Furkan Yılmaz',
      },
      {
        'product': 'P002 - Fren Kampanası',
        'testDate': '02.02.2026',
        'result': 'BAŞARILI',
        'tester': 'Ahmet Demir',
      },
      {
        'product': 'P003 - Fren Balatası',
        'testDate': '03.02.2026',
        'result': 'REDDEDİLDİ',
        'tester': 'Mehmet Yılmaz',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildHeaderCell('Ürün')),
                Expanded(child: _buildHeaderCell('Test Tarihi')),
                Expanded(child: _buildHeaderCell('Sonuç')),
                Expanded(flex: 2, child: _buildHeaderCell('Test Eden')),
              ],
            ),
          ),
          // Data rows
          ...sampleData.map((data) {
            final isSuccess = data['result'] == 'BAŞARILI';
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      data['product'] as String,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data['testDate'] as String,
                      style: const TextStyle(color: AppColors.textMain),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? AppColors.duzceGreen.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data['result'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSuccess
                              ? AppColors.duzceGreen
                              : AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      data['tester'] as String,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }
}
