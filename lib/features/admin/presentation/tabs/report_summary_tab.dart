import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/dashboard/quality_approval_card.dart';
import '../widgets/dashboard/final_control_card.dart';
import '../widgets/dashboard/rework_analysis_card.dart';
import '../widgets/dashboard/scrap_analysis_card.dart';
import '../widgets/dashboard/incoming_quality_card.dart';
import '../widgets/dashboard/personnel_performance_table.dart';
import '../widgets/dashboard/sample_test_card.dart';

class ReportSummaryTab extends StatefulWidget {
  const ReportSummaryTab({super.key});

  @override
  State<ReportSummaryTab> createState() => _ReportSummaryTabState();
}

class _ReportSummaryTabState extends State<ReportSummaryTab> {
  // Filtre State
  DateTimeRange? _selectedDateRange;
  String _selectedShift = 'Tümü';
  final List<String> _shifts = [
    'Tümü',
    '08:00 - 16:00',
    '16:00 - 00:00',
    '00:00 - 08:00',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilterRow(),
          const SizedBox(height: 24),

          // Row 1: Kalite Onay & Final Kontrol
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader(
                      '1. Kalite Onay',
                      LucideIcons.checkCircle,
                    ),
                    const QualityApprovalCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader(
                      '2. Final Kontrol',
                      LucideIcons.packageCheck,
                    ),
                    const FinalControlCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 2: Giriş Kalite & Fire Analizi
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader(
                      '3. Giriş Kalite',
                      LucideIcons.clipboardCheck,
                    ),
                    const IncomingQualityCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader('4. Fire Analizi', LucideIcons.flame),
                    const ScrapAnalysisCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 3: Rework Analizi & Numune Deneme
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader(
                      '5. Rework Analizi',
                      LucideIcons.refreshCw,
                    ),
                    const ReworkAnalysisCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader('6. Numune/Deneme', LucideIcons.beaker),
                    const SampleTestFormCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 4: Personel Performansı (Tam Genişlik)
          _buildSectionHeader('7. Personel Performansı', LucideIcons.users),
          const PersonnelPerformanceTable(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMain,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.filter, color: AppColors.primary),
          const SizedBox(width: 16),
          // Tarih Seçici
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2025),
                  lastDate: DateTime.now(),
                  barrierColor: Colors.black.withValues(
                    alpha: 0.5,
                  ), // BLUR EFFECT
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.primary,
                          surface: AppColors.surface,
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _selectedDateRange = picked);
                }
              },
              icon: const Icon(LucideIcons.calendar),
              label: Text(
                _selectedDateRange != null
                    ? '${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end)}'
                    : 'Tarih Aralığı Seç',
                style: const TextStyle(color: AppColors.textMain),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Vardiya Seçici
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedShift,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textMain),
                  isExpanded: true,
                  icon: const Icon(LucideIcons.clock, size: 16),
                  items: _shifts
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedShift = val!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
