import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/production_constants.dart';
import '../../../forms/domain/entities/fire_kayit_formu.dart';

part 'scrap_analysis_state.dart';

class ScrapAnalysisCubit extends Cubit<ScrapAnalysisState> {
  ScrapAnalysisCubit() : super(ScrapAnalysisState.initial()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Initial Mock Data
    final mockData = [
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '4210010',
        productionQty: 254,
        scrapQty: 2,
        defectReason: 'Elmas Kırması',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Kampana',
        productCode: '5025920',
        productionQty: 40,
        scrapQty: 1,
        defectReason: 'Darbeye Bağlı Kırık',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6310051',
        productionQty: 128,
        scrapQty: 1,
        defectReason: 'Malzeme Kaldırmış',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6310481',
        productionQty: 59,
        scrapQty: 4,
        defectReason: 'Elmas Kırması',
      ),
      ScrapData(
        factory: 'FRENBU',
        productType: 'Disk',
        productCode: '6312011',
        productionQty: 456,
        scrapQty: 3,
        defectReason: 'Robot Sensör Hatası',
      ),
      ScrapData(
        factory: 'D2',
        productType: 'Disk',
        productCode: '4810300',
        productionQty: 99,
        scrapQty: 2,
      ),
      ScrapData(
        factory: 'D2',
        productType: 'Disk',
        productCode: '6310481',
        productionQty: 59,
        scrapQty: 1,
      ),
      ScrapData(
        factory: 'D2',
        productType: 'Porya',
        productCode: '6340050',
        productionQty: 126,
        scrapQty: 1,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '1810360',
        productionQty: 27,
        scrapQty: 4,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '4210010',
        productionQty: 254,
        scrapQty: 10,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '4210020',
        productionQty: 268,
        scrapQty: 11,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Kampana',
        productCode: '5025940',
        productionQty: 112,
        scrapQty: 1,
      ),
      ScrapData(
        factory: 'D3',
        productType: 'Disk',
        productCode: '6312011',
        productionQty: 456,
        scrapQty: 29,
      ),
    ];
    emit(state.copyWith(scrapData: mockData, isLoading: false));
  }

  // Tarih Filtrelerini Güncelle
  void updateAnalysisDateRange(DateTime start, DateTime end) {
    emit(state.copyWith(analysisStartDate: start, analysisEndDate: end));
    // Not: Gerçek uygulamada burada verileri yeniden filtrelemek gerekebilir
  }

  void updateBackendDateRange(DateTime start, DateTime end) {
    emit(state.copyWith(backendStartDate: start, backendEndDate: end));
  }

  // Excel Verilerini İşle
  void importExcelData(String rawData) {
    emit(state.copyWith(isLoading: true));
    try {
      final List<ScrapData> newItems = [];
      final lines = rawData.split('\n');

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('\t');
        if (parts.length >= 5) {
          newItems.add(
            ScrapData(
              factory: parts[0].trim(),
              productType: parts[1].trim(),
              productCode: parts[2].trim(),
              productionQty: int.tryParse(parts[3].replaceAll('.', '')) ?? 0,
              scrapQty: int.tryParse(parts[4].replaceAll('.', '')) ?? 0,
              defectReason: parts.length > 5 ? parts[5].trim() : '',
            ),
          );
        }
      }

      if (newItems.isNotEmpty) {
        emit(state.copyWith(scrapData: newItems, isLoading: false));
      } else {
        throw Exception('Formatı uygun veri bulunamadı');
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // Backend Verilerini ScrapData'ya Dönüştür ve Ekle (Opsiyonel)
  void processBackendData(List<FireKayitFormu> forms) {
    // Bu metot backend verilerini alıp mevcut scrapData ile birleştirebilir veya
    // sadece backend verilerini gösterebilir.
    // Şimdilik sadece convert metodunun mantığını buraya taşıyoruz.
  }

  List<ScrapData> convertFireFormsToScrapData(List<FireKayitFormu> forms) {
    // Tarihe göre filtrele
    final filteredForms = forms.where((form) {
      final start = DateTime(
        state.analysisStartDate.year,
        state.analysisStartDate.month,
        state.analysisStartDate.day,
      );
      final end = DateTime(
        state.analysisEndDate.year,
        state.analysisEndDate.month,
        state.analysisEndDate.day,
        23,
        59,
        59,
      );
      return form.islemTarihi.isAfter(start) && form.islemTarihi.isBefore(end);
    }).toList();

    // Ürün bazında grupla
    final Map<String, List<FireKayitFormu>> groupedByProduct = {};
    for (final form in filteredForms) {
      groupedByProduct.putIfAbsent(form.urunKodu, () => []).add(form);
    }

    final List<ScrapData> scrapDataList = [];
    for (final entry in groupedByProduct.entries) {
      final productCode = entry.key;
      final records = entry.value;
      final scrapQty = records.length;
      final productionQty = scrapQty * 20; // Mock logic preserved

      scrapDataList.add(
        ScrapData(
          factory: ProductionConstants.defaultFactory,
          productType: ProductionConstants.defaultProductType,
          productCode: productCode,
          productionQty: productionQty,
          scrapQty: scrapQty,
          defectReason: records.first.retKodu ?? '',
        ),
      );
    }

    return scrapDataList;
  }
}
