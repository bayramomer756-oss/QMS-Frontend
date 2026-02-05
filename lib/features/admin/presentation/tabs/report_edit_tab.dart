import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../forms/presentation/fire_kayit/fire_kayit_screen.dart';
import '../../../forms/presentation/giris_kalite_kontrol_screen.dart';
import '../../../forms/presentation/final_kontrol_screen.dart';
import '../../../forms/presentation/rework_screen.dart';
import '../../../forms/presentation/saf_b9_counter_screen.dart';

class ReportEditTab extends StatefulWidget {
  const ReportEditTab({super.key});

  @override
  State<ReportEditTab> createState() => _ReportEditTabState();
}

class _ReportEditTabState extends State<ReportEditTab> {
  DateTime _selectedReportDate = DateTime.now();
  int _reportEditSubTab = 0; // 0: Yeni Kayıt, 1: Kayıt Düzenle/Sil

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle Buttons
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildToggleTab(
                    title: 'Geçmiş Kayıt Oluştur',
                    index: 0,
                    icon: LucideIcons.plusCircle,
                  ),
                ),
                Expanded(
                  child: _buildToggleTab(
                    title: 'Kayıt Düzenle/Sil',
                    index: 1,
                    icon: LucideIcons.edit,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_reportEditSubTab == 0)
            _buildNewHistoricalEntryView()
          else
            _buildEditDeleteView(),
        ],
      ),
    );
  }

  Widget _buildToggleTab({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _reportEditSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _reportEditSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Mode 0: Yeni Kayıt (Geçmiş) ---
  Widget _buildNewHistoricalEntryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.calendarDays, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Tarih Seçimi',
              style: TextStyle(
                color: AppColors.textMain,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedReportDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime.now(),
                  builder: (context, child) =>
                      Theme(data: ThemeData.dark(), child: child!),
                );
                if (picked != null) {
                  setState(() => _selectedReportDate = picked);
                }
              },
              icon: const Icon(LucideIcons.calendar),
              label: Text(
                DateFormat('dd.MM.yyyy').format(_selectedReportDate),
                style: const TextStyle(color: AppColors.textMain),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Seçili tarih için yeni bir form oluşturmak üzere aşağıdan seçim yapın.',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(5, (index) => _buildNewEntryItem(index)),
      ],
    );
  }

  Widget _buildNewEntryItem(int index) {
    final types = [
      'Fire Kayıt Formu',
      'Giriş Kalite Kontrol',
      'Final Kontrol',
      'Rework Takip',
      'SAF B9 Üretim',
    ];
    final icons = [
      LucideIcons.flame,
      LucideIcons.clipboardCheck,
      LucideIcons.packageCheck,
      LucideIcons.refreshCw,
      LucideIcons.factory,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icons[index % icons.length], color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  types[index],
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Hedef Tarih: ${DateFormat('dd.MM.yyyy').format(_selectedReportDate)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
            label: const Text('Oluştur'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _navigateToEditScreen(index),
          ),
        ],
      ),
    );
  }

  // --- Mode 1: Kayıt Düzenle/Sil ---
  Widget _buildEditDeleteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Son Kayıtlar',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Personel tarafından girilen son kayıtları buradan yönetebilirsiniz.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 16),
        ...List.generate(5, (index) => _buildExistingRecordItem(index)),
      ],
    );
  }

  Widget _buildExistingRecordItem(int index) {
    final types = [
      'Fire Kayıt',
      'Giriş Kalite',
      'Final Kontrol',
      'Rework',
      'SAF B9',
    ];
    final operators = [
      'Furkan Yılmaz',
      'Ahmet Demir',
      'Mehmet Yılmaz',
      'Ali Veli',
      'Mustafa Kaya',
    ];
    // Mock dates for recent records
    final date = DateTime.now().subtract(Duration(hours: index * 4));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      types[index % types.length],
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${1000 + index}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${operators[index % operators.length]} • ${DateFormat('dd.MM HH:mm').format(date)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              LucideIcons.edit,
              color: AppColors.primary,
              size: 18,
            ),
            tooltip: 'Düzenle',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User management coming soon'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen(int index) {
    Widget? screen;
    switch (index) {
      case 0: // Fire Kayıt
        screen = FireKayitScreen(initialDate: _selectedReportDate);
        break;
      case 1: // Giriş Kalite
        screen = GirisKaliteKontrolScreen(initialDate: _selectedReportDate);
        break;
      case 2: // Final Kontrol
        screen = FinalKontrolScreen(initialDate: _selectedReportDate);
        break;
      case 3: // Rework
        screen = ReworkScreen(initialDate: _selectedReportDate);
        break;
      case 4: // SAF B9
        screen = SafB9CounterScreen(initialDate: _selectedReportDate);
        break;
    }

    if (screen != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen!));
    }
  }
}
