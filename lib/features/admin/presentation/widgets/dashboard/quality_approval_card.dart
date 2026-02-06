import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class QualityApprovalCard extends StatelessWidget {
  const QualityApprovalCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data: Disk, Kampana, Poyra
    final data = [
      {'type': 'Disk', 'ok': 150, 'nok': 3},
      {'type': 'Kampana', 'ok': 85, 'nok': 1},
      {'type': 'Poyra', 'ok': 42, 'nok': 0},
    ];

    int totalOk = 277;
    int totalNok = 4;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Toplam Özet
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  'Toplam Uygun',
                  totalOk.toString(),
                  AppColors.duzceGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoBox(
                  'Toplam Ret',
                  totalNok.toString(),
                  AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Detay Tablosu
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Ürün Grubu',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Uygun',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Ret',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ...data.map(
                (item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        item['type'] as String,
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${item['ok']}',
                        style: const TextStyle(color: AppColors.duzceGreen),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${item['nok']}',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05), // White bg (translucent)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ), // White border
      ),
      child: Column(
        children: [
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
            style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
