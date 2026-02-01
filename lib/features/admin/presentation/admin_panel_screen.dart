import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../auth/presentation/login_screen.dart';
import '../../chat/presentation/shift_notes_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../forms/presentation/forms_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'scrap_analysis_tab.dart';
import '../../forms/presentation/fire_kayit/fire_kayit_screen.dart';
import '../../forms/presentation/giris_kalite_kontrol_screen.dart';
import '../../forms/presentation/final_kontrol_screen.dart';
import '../../forms/presentation/rework_screen.dart';
import '../../forms/presentation/saf_b9_counter_screen.dart';

// Üretim Verisi Modeli
class _ProductionData {
  final String productCode;
  final String line; // D2 veya D3
  final int quantity;

  _ProductionData({
    required this.productCode,
    required this.line,
    required this.quantity,
  });
}

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _operatorName = 'Admin';

  // Filtre State
  DateTimeRange? _selectedDateRange;
  String _selectedShift = 'Tümü';
  final List<String> _shifts = [
    'Tümü',
    '08:00 - 16:00',
    '16:00 - 00:00',
    '00:00 - 08:00',
  ];

  // State (Ignored unused warning applied)
  // ignore: unused_field
  final List<_ProductionData> _productionDataList = [];

  // Mock Personel Performans Verisi
  final List<Map<String, dynamic>> _personnelPerformance = [
    {'name': 'Furkan Yılmaz', 'total': 120, 'defects': 5, 'efficiency': 95},
    {'name': 'Ahmet Demir', 'total': 98, 'defects': 8, 'efficiency': 91},
    {'name': 'Mehmet Yılmaz', 'total': 105, 'defects': 2, 'efficiency': 98},
    {'name': 'Ali Veli', 'total': 85, 'defects': 1, 'efficiency': 99},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
          ),
          Row(
            children: [
              SidebarNavigation(
                selectedIndex: -1, // Admin panel
                onItemSelected: (index) {
                  if (index == 0) {
                    Navigator.of(context).pop();
                  } else if (index == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FormsScreen()),
                    );
                  } else if (index == 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  } else if (index == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShiftNotesScreen(),
                      ),
                    );
                  } else if (index == 4) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                },
                operatorInitial: _operatorName.isNotEmpty
                    ? _operatorName[0]
                    : 'A',
                onLogout: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                LucideIcons.arrowLeft,
                                color: AppColors.textMain,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              LucideIcons.shield,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Yönetici Paneli',
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Image.asset('assets/images/logo.png', height: 48),
                          ],
                        ),
                      ),

                      // Tab Bar
                      Container(
                        color: AppColors.surface,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              icon: Icon(LucideIcons.barChart2),
                              text: 'Rapor Özetleri',
                            ),
                            Tab(
                              icon: Icon(LucideIcons.fileEdit),
                              text: 'Rapor Düzenleme',
                            ),
                            Tab(
                              icon: Icon(LucideIcons.pieChart),
                              text: 'Fire Analizi',
                            ),
                            Tab(
                              icon: Icon(LucideIcons.users),
                              text: 'Kullanıcı Yönetimi',
                            ),
                            Tab(
                              icon: Icon(LucideIcons.database),
                              text: 'Sabit Veriler',
                            ),
                          ],
                        ),
                      ),

                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildReportSummaryTab(),
                            _buildReportEditTab(),
                            const ScrapAnalysisTab(),
                            _buildUserManagementTab(),
                            _buildMasterDataTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 1. Rapor Özetleri Tab ---
  Widget _buildReportSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilterRow(),
          const SizedBox(height: 32),

          // 1. Kalite Onay
          _buildSectionHeader('1. Kalite Onay Özeti', LucideIcons.checkCircle),
          _buildQualityApprovalCard(),
          const SizedBox(height: 24),

          // 2. Final Kontrol
          _buildSectionHeader(
            '2. Final Kontrol Özeti',
            LucideIcons.packageCheck,
          ),
          _buildFinalControlCard(),
          const SizedBox(height: 24),

          // 3. Rework Analizi
          _buildSectionHeader('3. Rework Analizi', LucideIcons.refreshCw),
          _buildReworkAnalysisCard(),
          const SizedBox(height: 24),

          // 4. Fire Analizi
          _buildSectionHeader(
            '4. Fire Analizi (D2 / D3 / Frenbu)',
            LucideIcons.flame,
          ),
          _buildScrapAnalysisCard(),
          const SizedBox(height: 24),

          // 5. Giriş Kalite
          _buildSectionHeader(
            '5. Giriş Kalite Özeti',
            LucideIcons.clipboardCheck,
          ),
          _buildIncomingQualityCard(),
          const SizedBox(height: 24),

          // 6. Personel Performansı
          _buildSectionHeader('6. Personel Performansı', LucideIcons.users),
          _buildPerformanceTable(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMain,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- Kalite Onay Kartı ---
  Widget _buildQualityApprovalCard() {
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

  // --- Final Kontrol Kartı ---
  Widget _buildFinalControlCard() {
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

  // --- Rework Analizi ---
  Widget _buildReworkAnalysisCard() {
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
      padding: const EdgeInsets.all(20),
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
                        color: AppColors.surfaceLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
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
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: 8,
                          width: 20.0 * (e['qty'] as int),
                          decoration: BoxDecoration(
                            color: AppColors.reworkOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  // --- Fire Analizi ---
  Widget _buildScrapAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(child: _buildInfoBox('D2 Hattı', '12', Colors.blue)),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoBox('D3 Hattı', '8', Colors.purple)),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoBox('Frenbu', '5', Colors.orange)),
        ],
      ),
    );
  }

  // --- Giriş Kalite Kartı ---
  Widget _buildIncomingQualityCard() {
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
                  builder: (context, child) =>
                      Theme(data: ThemeData.dark(), child: child!),
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

  Widget _buildPerformanceTable() {
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
          ..._personnelPerformance.map((p) {
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

  // --- Header Helpers ---
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

  // --- Master Data Tab ---
  Widget _buildMasterDataTab() {
    // TODO: Implement Master Data management with Clean Architecture
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.construction,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Master Data Yönetimi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bu özellik Clean Architecture ile\nyeniden geliştirilecek',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planlanmış Özellikler:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem('• Ürün Yönetimi'),
                  _buildFeatureItem('• Tezgah Yönetimi'),
                  _buildFeatureItem('• Bölge Yönetimi'),
                  _buildFeatureItem('• Hata Kodları'),
                  _buildFeatureItem('• Rework Sonuçları'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  // LEGACY METHOD - Disabled until Master Data feature is implemented with Clean Architecture
  /* 
  void _showAddMasterDataDialog(MasterDataNotifier notifier) {
    // Implementation commented out - requires MasterDataNotifier from Clean Architecture
  }
  */

  DateTime _selectedReportDate = DateTime.now();

  // 0: Yeni Kayıt (Geçmiş), 1: Kayıt Düzenle/Sil
  int _reportEditSubTab = 0;

  Widget _buildReportEditTab() {
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
              // Mock Edit Action - User management not implemented yet
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

  Widget _buildUserManagementTab() {
    // TODO: Implement User Management with proper backend API support
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.users, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 24),
            Text(
              'Kullanıcı Yönetimi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bu özellik backend API ile\nbirlikte geliştirilecek',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gerekli Backend Endpoints:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem('• GET /api/users - Tüm kullanıcılar'),
                  _buildFeatureItem('• POST /api/users - Yeni kullanıcı'),
                  _buildFeatureItem('• PUT /api/users/:id - Güncelle'),
                  _buildFeatureItem('• DELETE /api/users/:id - Sil'),
                  _buildFeatureItem(
                    '• POST /api/users/:id/password - Şifre değiştir',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LEGACY USER MANAGEMENT METHODS - Disabled until backend supports user CRUD
  /*
  Widget _buildUserItem(UserModel user) {
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: user.isAdmin
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.duzceGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                user.fullName[0].toUpperCase(),
                style: TextStyle(
                  color: user.isAdmin
                      ? AppColors.primary
                      : AppColors.duzceGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: user.isAdmin
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.duzceGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.isAdmin ? 'Admin' : 'Operatör',
                        style: TextStyle(
                          color: user.isAdmin
                              ? AppColors.primary
                              : AppColors.duzceGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Kullanıcı adı: ${user.username}',
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
              size: 20,
            ),
            onPressed: () => _showEditUserDialog(user),
          ),
          IconButton(
            icon: const Icon(LucideIcons.key, color: Colors.orange, size: 20),
            onPressed: () => _showChangePasswordDialog(user),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Kaydı Sil',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: const Text(
          'Bu kaydı silmek istediğinizden emin misiniz?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kayıt silindi (Simülasyon)'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final usernameController = TextEditingController();
    final fullNameController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();
    final emergencyController = TextEditingController();
    DateTime? selectedDate;
    final dateController = TextEditingController();

    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Yeni Kullanıcı Ekle',
            style: TextStyle(color: AppColors.textMain),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fullNameController,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Ad Soyad',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: usernameController,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Telefon Numarası',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dateController,
                    style: const TextStyle(color: AppColors.textMain),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(1950),
                        builder: (context, child) =>
                            Theme(data: ThemeData.dark(), child: child!),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        dateController.text = DateFormat(
                          'dd.MM.yyyy',
                        ).format(picked);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Doğum Tarihi',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      suffixIcon: Icon(
                        LucideIcons.calendar,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emergencyController,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: 'Acil Durum Yakını (Ad - Tel)',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isAdmin,
                        onChanged: (v) =>
                            setDialogState(() => isAdmin = v ?? false),
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Yönetici Yetkisi',
                        style: TextStyle(color: AppColors.textMain),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${fullNameController.text} eklendi'),
                    backgroundColor: AppColors.duzceGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.duzceGreen,
              ),
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(UserModel user) {
    final fullNameController = TextEditingController(text: user.fullName);
    final usernameController = TextEditingController(text: user.username);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final emergencyController = TextEditingController(
      text: user.emergencyContact,
    );
    final dateController = TextEditingController(
      text: user.birthDate != null
          ? DateFormat('dd.MM.yyyy').format(user.birthDate!)
          : '',
    );
    final passwordController = TextEditingController(); // Şifre değiştirme için
    DateTime? selectedDate = user.birthDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Kullanıcı Düzenle',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    labelText: 'Telefon Numarası',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  style: const TextStyle(color: AppColors.textMain),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) =>
                          Theme(data: ThemeData.dark(), child: child!),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                      dateController.text = DateFormat(
                        'dd.MM.yyyy',
                      ).format(picked);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Doğum Tarihi',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    suffixIcon: Icon(
                      LucideIcons.calendar,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emergencyController,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    labelText: 'Acil Durum Yakını (Ad - Tel)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 12),
                // Yeni Şifre Alanı
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    labelText: 'Yeni Şifre (Değiştirmek istiyorsanız girin)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    helperText: 'Boş bırakırsanız mevcut şifre korunur',
                    helperStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (passwordController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kullanıcı ve şifre güncellendi'),
                    backgroundColor: AppColors.duzceGreen,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kullanıcı güncellendi'),
                    backgroundColor: AppColors.duzceGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.duzceGreen,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(UserModel user) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Şifre Değiştir - ${user.fullName}',
          style: const TextStyle(color: AppColors.textMain),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.textMain),
              decoration: const InputDecoration(
                labelText: 'Yeni Şifre',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.textMain),
              decoration: const InputDecoration(
                labelText: 'Şifre Tekrar',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Şifre güncellendi'),
                  backgroundColor: AppColors.duzceGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Değiştir'),
          ),
        ],
      ),
    );
  }
  */
}
