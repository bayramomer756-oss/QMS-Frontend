import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'analysis_isolate.dart';

class ScrapAnalysisState {
  final bool isLoading;
  final String? error;
  final AnalysisResult? result;

  ScrapAnalysisState({this.isLoading = false, this.error, this.result});

  ScrapAnalysisState copyWith({
    bool? isLoading,
    String? error,
    AnalysisResult? result,
  }) {
    return ScrapAnalysisState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      result: result ?? this.result,
    );
  }
}

class ScrapAnalysisNotifier extends Notifier<ScrapAnalysisState> {
  @override
  ScrapAnalysisState build() {
    return ScrapAnalysisState();
  }

  Future<void> analyzeExcel(List<int> excelBytes) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 1. Get Fire List (MOCK BYPASS)
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay

      final fireData = [
        FireAnalysisData(
          productCode: '4210010',
          defectCode: 'Tİ-01',
          batchNo: '24F123',
        ),
        FireAnalysisData(
          productCode: '6312011',
          defectCode: 'D-05',
          batchNo: '24A456',
        ),
        FireAnalysisData(
          productCode: 'FRB-900',
          defectCode: 'Tİ-02',
          batchNo: '24F789',
        ),
        FireAnalysisData(
          productCode: 'FRB-800',
          defectCode: 'H-10',
          batchNo: '24A101',
        ),
      ];

      // 3. Prepare Input
      final input = AnalysisInput(
        excelBytes: excelBytes,
        fireData: fireData,
      ); // 4. Run Isolate
      // compute spawns a separate isolate to run analyzeScrapData
      final result = await compute(analyzeScrapData, input);

      state = state.copyWith(isLoading: false, result: result);
    } catch (e, stack) {
      debugPrint('Analysis Error: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        error: 'Analiz sırasında hata oluştu: $e',
      );
    }
  }

  void loadDemoData() {
    state = state.copyWith(isLoading: true, error: null);

    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        isLoading: false,
        result: AnalysisResult(
          d2Production: 15420,
          d3Production: 12850,
          frenbuCount: 42,
          nonScrapItems: [
            ProductionEntry(
              productCode: 'TR-552',
              factoryType: 'D2',
              quantity: 500,
            ),
            ProductionEntry(
              productCode: 'TR-999',
              factoryType: 'D3',
              quantity: 120,
            ),
            ProductionEntry(
              productCode: 'FRB-101',
              factoryType: 'D2',
              quantity: 2500,
            ),
            ProductionEntry(
              productCode: 'FRB-202',
              factoryType: 'D3',
              quantity: 1800,
            ),
          ],
        ),
      );
    });
  }

  void reset() {
    state = ScrapAnalysisState();
  }
}

final scrapAnalysisProvider =
    NotifierProvider<ScrapAnalysisNotifier, ScrapAnalysisState>(
      ScrapAnalysisNotifier.new,
    );
