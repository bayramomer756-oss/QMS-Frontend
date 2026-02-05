import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class PersonnelPerformanceTable extends StatelessWidget {
  const PersonnelPerformanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Personel Performans Verisi
    final List<Map<String, dynamic>> personnelPerformance = [
      {'name': 'Furkan Yılmaz', 'total': 120, 'defects': 5, 'efficiency': 95},
      {'name': 'Ahmet Demir', 'total': 98, 'defects': 8, 'efficiency': 91},
      {'name': 'Mehmet Yılmaz', 'total': 105, 'defects': 2, 'efficiency': 98},
      {'name': 'Ali Veli', 'total': 85, 'defects': 1, 'efficiency': 99},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildHeaderCell('Personel')),
                Expanded(child: _buildHeaderCell('Kontrol')),
                Expanded(child: _buildHeaderCell('Hata')),
                Expanded(child: _buildHeaderCell('Başarı %')),
                Expanded(flex: 2, child: _buildHeaderCell('Durum')),
              ],
            ),
          ),
          ...personnelPerformance.map((p) {
            final double efficiency = (p['efficiency'] as int).toDouble();
            final int total = p['total'] as int;
            final int defects = p['defects'] as int;

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
                      p['name'] as String,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$total Adet',
                      style: const TextStyle(color: AppColors.textMain),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$defects Adet',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '%$efficiency',
                      style: const TextStyle(
                        color: AppColors.duzceGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: efficiency / 100,
                          backgroundColor: AppColors.surfaceLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            efficiency > 90
                                ? AppColors.duzceGreen
                                : AppColors.reworkOrange,
                          ),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
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
