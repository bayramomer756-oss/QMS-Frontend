import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../forms/presentation/providers/fire_kayit_providers.dart';
import '../logic/cubits/scrap_analysis_cubit.dart';
import 'widgets/scrap_factory_table.dart';
import 'widgets/scrap_pie_chart.dart';
import 'widgets/scrap_summary_cards.dart';

class ScrapAnalysisTab extends ConsumerStatefulWidget {
  const ScrapAnalysisTab({super.key});

  @override
  ConsumerState<ScrapAnalysisTab> createState() => _ScrapAnalysisTabState();
}

class _ScrapAnalysisTabState extends ConsumerState<ScrapAnalysisTab>
    with SingleTickerProviderStateMixin {
  late TabController _factoryTabController;

  @override
  void initState() {
    super.initState();
    _factoryTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _factoryTabController.dispose();
    super.dispose();
  }

  void _showExcelDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Excel\'den Yapıştır',
            style: TextStyle(color: AppColors.textMain),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Excel verilerini kopyalayıp (Ctrl+C) aşağıdaki alana yapıştırın (Ctrl+V).\nFormat: Fabrika | Ürün Tipi | Ürün Kodu | Üretim | Fire | Hata Nedeni (Opsiyonel)',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 10,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'FRENBU\tDisk\t4210010\t254\t2\tElmas Kırması...',
                  ),
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
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.duzceGreen,
              ),
              child: const Text('Verileri İşle'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      context.read<ScrapAnalysisCubit>().importExcelData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScrapAnalysisCubit(),
      child: Builder(
        builder: (context) {
          // Listen to Riverpod provider and update Cubit
          ref.listen(fireKayitFormsProvider, (previous, next) {
            next.whenData((forms) {
              // Update Cubit with backend data if needed
              // For now, we handle conversion inside build or a dedicated method
              // Ideally, we'd pass this to the Cubit once
            });
          });

          return Column(
            children: [
              // Header & Actions
              _buildHeader(context),

              // Content
              Expanded(
                child: BlocBuilder<ScrapAnalysisCubit, ScrapAnalysisState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.error != null) {
                      return Center(child: Text('Hata: ${state.error}'));
                    }

                    // Merge Mock/Excel Data + Backend Data (if implemented)
                    // For now, using state.scrapData which has Mock + Excel

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Toplam Özet Kartları
                          ScrapSummaryCards(data: state.scrapData),
                          const SizedBox(height: 24),

                          // Pasta Grafik
                          ScrapPieChart(data: state.scrapData),
                          const SizedBox(height: 24),

                          // Fabrika Detay Tabloları
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _factoryTabController,
                                  labelColor: AppColors.textMain,
                                  unselectedLabelColor: AppColors.textSecondary,
                                  indicatorColor: AppColors.primary,
                                  tabs: const [
                                    Tab(text: 'FRENBU'),
                                    Tab(text: 'D2 FABRİKA'),
                                    Tab(text: 'D3 FABRİKA'),
                                  ],
                                ),
                                SizedBox(
                                  height: 500,
                                  child: TabBarView(
                                    controller: _factoryTabController,
                                    children: [
                                      ScrapFactoryTable(
                                        data: state.scrapData,
                                        factory: 'FRENBU',
                                      ),
                                      ScrapFactoryTable(
                                        data: state.scrapData,
                                        factory: 'D2',
                                      ),
                                      ScrapFactoryTable(
                                        data: state.scrapData,
                                        factory: 'D3',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Backend Fire Section (kept simplified or refactored)
                          // For this refactor, we focus on the main analysis parts
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fire Oranlama Analizi',
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Geçmişe yönelik fire analizi',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showExcelDialog(context),
                icon: const Icon(LucideIcons.upload, size: 18),
                label: const Text('Excel Yükle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.duzceGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Date Filter Widget (could be extracted later)
          _buildDateFilter(context),
        ],
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return BlocBuilder<ScrapAnalysisCubit, ScrapAnalysisState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 12),
              const Text(
                'Analiz Dönemi:',
                style: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              _buildDatePicker(context, 'Başlangıç', state.analysisStartDate, (
                date,
              ) {
                context.read<ScrapAnalysisCubit>().updateAnalysisDateRange(
                  date,
                  state.analysisEndDate,
                );
              }),
              const SizedBox(width: 12),
              const Icon(
                LucideIcons.arrowRight,
                color: AppColors.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 12),
              _buildDatePicker(context, 'Bitiş', state.analysisEndDate, (date) {
                context.read<ScrapAnalysisCubit>().updateAnalysisDateRange(
                  state.analysisStartDate,
                  date,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onSelect,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  surface: AppColors.surface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onSelect(picked);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy').format(date),
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(
              LucideIcons.calendar,
              color: AppColors.primary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
