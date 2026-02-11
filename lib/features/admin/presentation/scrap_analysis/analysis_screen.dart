import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_colors.dart';
import 'analysis_provider.dart';
import 'models.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  DateTime? _selectedFilterDate;
  final TextEditingController _productionController = TextEditingController();
  int? _manualProductionQty;

  @override
  void dispose() {
    _productionController.dispose();
    super.dispose();
  }

  Future<void> _pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null) {
        List<int>? bytes = result.files.single.bytes;

        if (bytes == null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          bytes = await file.readAsBytes();
        }

        if (bytes != null) {
          ref.read(scrapAnalysisProvider.notifier).parseExcel(bytes);
        } else {
          _showError('Dosya okunamadı: İçerik boş.');
        }
      }
    } catch (e) {
      _showError('Dosya seçimi hatası: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scrapAnalysisProvider);
    final data = state.dashboardData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(data),
            const SizedBox(height: 20),

            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (data == null)
              _buildEmptyState()
            else
              _buildDashboard(data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ScrapDashboardData? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.pieChart,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fire Analiz Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                if (data != null)
                  Text(
                    'Veri Tarihi: ${DateFormat('dd.MM.yyyy').format(data.date)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Date Filter - Always visible
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: TextButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedFilterDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: AppColors.surface,
                            onSurface: AppColors.textMain,
                          ),
                          dialogTheme: const DialogThemeData(
                            backgroundColor: AppColors.surface,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedFilterDate = picked;
                    });
                  }
                },
                icon: const Icon(
                  LucideIcons.calendar,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                label: Text(
                  _selectedFilterDate != null
                      ? DateFormat('dd.MM.yyyy').format(_selectedFilterDate!)
                      : 'Tarih Seçiniz',
                  style: const TextStyle(color: AppColors.textMain),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Filter Button - Always visible
            ElevatedButton.icon(
              onPressed: _selectedFilterDate != null
                  ? () {
                      // Trigger data filter
                      // In real implementation: ref.read(scrapAnalysisProvider.notifier).filterByDate(_selectedFilterDate!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tarih filtresi: ${DateFormat('dd.MM.yyyy').format(_selectedFilterDate!)}',
                          ),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(LucideIcons.search, size: 18),
              label: const Text('Filtrele'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surface,
                disabledForegroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 16),

            ElevatedButton.icon(
              onPressed: _pickExcelFile,
              icon: const Icon(LucideIcons.upload, size: 18),
              label: const Text('Yeni Analiz Yükle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileSpreadsheet,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analiz sonucunu görüntülemek için Excel dosyası yükleyiniz.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Date Picker in Empty State
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedFilterDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          surface: AppColors.surface,
                          onSurface: AppColors.textMain,
                        ),
                        dialogTheme: const DialogThemeData(
                          backgroundColor: AppColors.surface,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedFilterDate = picked;
                  });
                }
              },
              icon: const Icon(
                LucideIcons.calendar,
                color: AppColors.textSecondary,
                size: 18,
              ),
              label: Text(
                _selectedFilterDate != null
                    ? 'Seçili Tarih: ${DateFormat('dd.MM.yyyy').format(_selectedFilterDate!)}'
                    : 'Veri Tarihi Seçiniz',
                style: const TextStyle(color: AppColors.textMain),
              ),
            ),
          ),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickExcelFile,
            icon: const Icon(LucideIcons.upload),
            label: const Text('Excel Yükle'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(ScrapDashboardData data) {
    return Column(
      children: [
        // 1. Summary Cards (Vertical) & Pie Chart
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical Summary Cards
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard(
                      'D2 FABRİKA',
                      data.summary.d2Rate,
                      data.summary.d2ScrapDto,
                      data.summary.d2Turned,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      'D3 FABRİKA',
                      data.summary.d3Rate,
                      data.summary.d3ScrapDto,
                      data.summary.d3Turned,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      'FRENBU',
                      data.summary.frenbuRate,
                      data.summary.frenbuScrapDto,
                      _manualProductionQty ?? data.summary.frenbuTurned,
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Pie Chart
              Expanded(flex: 3, child: _buildChartSection(data)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Production Input Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.packagePlus,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Üretim Adeti Girişi:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _productionController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: InputDecoration(
                    hintText: 'Üretim adetini giriniz',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final value = int.tryParse(_productionController.text);
                  if (value != null && value > 0) {
                    setState(() {
                      _manualProductionQty = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Üretim adeti kaydedildi: $value'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(LucideIcons.check, size: 18),
                label: const Text('Kaydet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 2. Frenbu Distribution & Frenbu Table (Side by Side)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frenbu Distribution
            Expanded(
              child: _buildDistributionTable(data.frenbuDefectDistribution),
            ),
            const SizedBox(width: 24),
            // Frenbu Table
            Expanded(
              child: _buildScrapTable(
                'FRENBU FİRE TABLOSU',
                data.frenbuTable,
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 3. D2 & D3 Tables in Single Row: D2 Fire, D2 Clean, D3 Clean, D3 Fire
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildScrapTable('D2 DIŞ FİRE', data.d2Table, Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCleanTable(
                'D2 FİRESİZ ÜRÜNLER',
                data.d2CleanProducts,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCleanTable(
                'D3 FİRESİZ ÜRÜNLER',
                data.d3CleanProducts,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildScrapTable(
                'D3 DIŞ FİRE',
                data.d3Table,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double rate,
    int scrapQty,
    int totalQty,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${rate.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fire Adeti',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$scrapQty',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Üretim',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalQty',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(ScrapDashboardData data) {
    final sections = data.dailyScrapRates.map((item) {
      final color = item.factory == 'D2'
          ? Colors.blue
          : (item.factory == 'D3' ? Colors.orange : AppColors.primary);
      return PieChartSectionData(
        color: color,
        value: item.rate,
        title: '${item.rate.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Günlük Fire Oramları Dağılımı',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.dailyScrapRates.map((e) {
              final color = e.factory == 'D2'
                  ? Colors.blue
                  : (e.factory == 'D3' ? Colors.orange : AppColors.primary);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: color),
                    const SizedBox(width: 4),
                    Text(e.factory, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScrapTable(
    String title,
    List<ScrapTableItem> items,
    Color headerColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: headerColor.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Table(
            border: TableBorder.all(color: AppColors.border, width: 1.5),
            columnWidths: const {
              0: FlexColumnWidth(1.5), // Tür - wider
              1: FlexColumnWidth(1.5), // Kod
              2: FlexColumnWidth(1), // Üretim
              3: FlexColumnWidth(1), // Fire
              4: FlexColumnWidth(1.2), // Oran
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppColors.surfaceLight),
                children: [
                  _HeaderCell('Ürün Türü'),
                  _HeaderCell('Ürün Kodu'),
                  _HeaderCell('Üretim'),
                  _HeaderCell('Fire'),
                  _HeaderCell('Oran'),
                ],
              ),
              ...items.map(
                (item) => TableRow(
                  children: [
                    _DataCell(item.productType),
                    _DataCell(item.productCode, isBold: true),
                    _DataCell('${item.productionQty}'),
                    _DataCell('${item.scrapQty}'),
                    _DataCell(
                      '${item.scrapRate.toStringAsFixed(1)}%',
                      // Always white, no auto-red
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Kayıt bulunamadı.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  // NEW: Clean Products Table
  Widget _buildCleanTable(
    String title,
    List<ProductionEntry> items,
    Color headerColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.2), // Lighter header
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                color: headerColor, // Colored text
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Table(
            border: TableBorder.all(color: AppColors.border, width: 1.5),
            columnWidths: const {
              0: FlexColumnWidth(1.5), // Kod - wider
              1: FlexColumnWidth(1), // Üretim
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppColors.surfaceLight),
                children: [
                  _HeaderCell('Ürün Kodu'),
                  _HeaderCell('Üretim Adeti'),
                ],
              ),
              ...items.map(
                (item) => TableRow(
                  children: [
                    _DataCell(item.productCode, isBold: true),
                    _DataCell('${item.quantity}'),
                  ],
                ),
              ),
            ],
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Kayıt bulunamadı.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDistributionTable(List<DefectDistributionItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            width: double.infinity,
            child: const Text(
              'FRENBU FİRE DAĞILIMI',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Table(
            border: TableBorder.all(color: AppColors.border, width: 1.5),
            columnWidths: const {
              0: FlexColumnWidth(3.0), // Hata Tanımı - wider
              1: FlexColumnWidth(1.0), // Disk - narrow
              2: FlexColumnWidth(1.2), // Kampana - narrow
              3: FlexColumnWidth(1.0), // Porya - narrow
              4: FlexColumnWidth(1.0), // Toplam
              5: FlexColumnWidth(1.0), // Oran - narrow
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppColors.surfaceLight),
                children: [
                  _HeaderCell('Hata Tanımı', align: TextAlign.left),
                  _HeaderCell('Disk'),
                  _HeaderCell('Kamp.', fontSize: 11),
                  _HeaderCell('Porya'),
                  _HeaderCell('Top.', fontSize: 11),
                  _HeaderCell('Oran'),
                ],
              ),
              ...items.map(
                (item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Text(
                        item.defectName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    _DataCell(item.diskScrap > 0 ? '${item.diskScrap}' : ''),
                    _DataCell(item.drumScrap > 0 ? '${item.drumScrap}' : ''),
                    _DataCell(item.hubScrap > 0 ? '${item.hubScrap}' : ''),
                    _DataCell('${item.total}', isBold: true),
                    _DataCell('${item.rate.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double? fontSize;
  const _HeaderCell(this.text, {this.align = TextAlign.center, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 13,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final bool isBold;
  const _DataCell(this.text, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: AppColors.textMain,
        ),
      ),
    );
  }
}
