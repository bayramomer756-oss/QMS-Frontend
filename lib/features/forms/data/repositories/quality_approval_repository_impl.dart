import '../../domain/entities/quality_approval_form.dart';
import '../../domain/repositories/i_quality_approval_repository.dart';
import '../datasources/quality_approval_remote_datasource.dart';
import '../models/quality_approval_form_dto.dart';

class QualityApprovalRepositoryImpl implements IQualityApprovalRepository {
  final QualityApprovalRemoteDataSource _remoteDataSource;

  QualityApprovalRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<QualityApprovalForm>> getAll() async {
    final dtos = await _remoteDataSource.getAll();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<QualityApprovalForm> getById(int id) async {
    final dto = await _remoteDataSource.getById(id);
    return dto.toEntity();
  }

  @override
  Future<int> create(QualityApprovalForm form) async {
    final dto = QualityApprovalFormDto(
      id: form.id,
      urunKodu: form.urunKodu,
      urunAdi: form.urunAdi,
      urunTuru: form.urunTuru,
      adet: form.adet,
      uygunlukDurumu: form.uygunlukDurumu,
      retKoduId: form.retKoduId,
      aciklama: form.aciklama,
      kayitTarihi: form.kayitTarihi,
    );
    return await _remoteDataSource.create(dto.toJson());
  }

  @override
  Future<void> update(QualityApprovalForm form) async {
    final dto = QualityApprovalFormDto(
      id: form.id,
      urunKodu: form.urunKodu,
      urunAdi: form.urunAdi,
      urunTuru: form.urunTuru,
      adet: form.adet,
      uygunlukDurumu: form.uygunlukDurumu,
      retKoduId: form.retKoduId,
      aciklama: form.aciklama,
      kayitTarihi: form.kayitTarihi,
    );
    await _remoteDataSource.update(form.id!, dto.toJson());
  }

  @override
  Future<void> delete(int id) async {
    await _remoteDataSource.delete(id);
  }
}
