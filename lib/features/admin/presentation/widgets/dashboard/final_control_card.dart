import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class FinalControlCard extends StatelessWidget {
  const FinalControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Disk, Kampana, Poyra -> Paket, Hurda, Rework
    final data = [
      {'type': 'Disk', 'paket': 120, 'hurda': 2, 'rework': 5},
      {'type': 'Kampana', 'paket': 80, 'hurda': 1, 'rework': 2},
      {'type': 'Poyra', 'paket': 40, 'hurda': 0, 'rework': 1},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoBox('Toplam Paket', '240', Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox('Toplam Hurda', '3', AppColors.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  'Toplam Rework',
                  '8',
                  AppColors.reworkOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                      'Ürün',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Paket',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Hurda',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Rework',
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
                        '${item['paket']}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${item['hurda']}',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${item['rework']}',
                        style: const TextStyle(color: AppColors.reworkOrange),
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
