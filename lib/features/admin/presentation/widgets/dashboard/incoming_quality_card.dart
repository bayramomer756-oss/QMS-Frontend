import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class IncomingQualityCard extends StatelessWidget {
  const IncomingQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoBox('Toplam Kontrol', '50', AppColors.textMain),
          ),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoBox('Kabul', '45', AppColors.duzceGreen)),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoBox('Ret', '5', AppColors.error)),
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
