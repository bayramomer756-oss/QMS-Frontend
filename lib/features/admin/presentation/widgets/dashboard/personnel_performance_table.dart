import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

    // Sıralama: Verimliliğe göre (Yüksekten düşüğe)
    personnelPerformance.sort(
      (a, b) => (b['efficiency'] as int).compareTo(a['efficiency'] as int),
    );

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Icon(LucideIcons.users, size: 20, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                'Personel Performans Özeti',
                style: TextStyle(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ...personnelPerformance.map((p) => _PersonnelCard(data: p)),
      ],
    );
  }
}

class _PersonnelCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _PersonnelCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final String name = data['name'];
    final int total = data['total'];
    final int defects = data['defects'];
    final int efficiency = data['efficiency'];

    // Renk skalası
    final Color efficiencyColor = efficiency >= 95
        ? AppColors.duzceGreen
        : efficiency >= 90
        ? AppColors.reworkOrange
        : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.glassBorder, // Subtle border
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // İsim ve Avatar
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfaceLight,
                    child: Text(
                      name.substring(0, 1),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$total Üretim',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Verimlilik Rozeti
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: efficiencyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: efficiencyColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.activity,
                      size: 14,
                      color: efficiencyColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '%$efficiency',
                      style: TextStyle(
                        color: efficiencyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // İstatistikler (Hata & Bar)
          Row(
            children: [
              // Hata Sayısı
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.alertCircle,
                      size: 12,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$defects Hata',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: efficiency / 100,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(efficiencyColor),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
