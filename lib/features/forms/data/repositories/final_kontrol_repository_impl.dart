import '../../domain/entities/final_kontrol_form.dart';
import '../../domain/repositories/i_final_kontrol_repository.dart';
import '../datasources/final_kontrol_remote_datasource.dart';
import '../models/final_kontrol_form_dto.dart';

class FinalKontrolRepositoryImpl implements IFinalKontrolRepository {
  final FinalKontrolRemoteDataSource _remoteDataSource;

  FinalKontrolRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<FinalKontrolForm>> getAll() async {
    final dtos = await _remoteDataSource.getAll();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<FinalKontrolForm> getById(int id) async {
    final dto = await _remoteDataSource.getById(id);
    return dto.toEntity();
  }

  @override
  Future<int> create(FinalKontrolForm form) async {
    final dto = FinalKontrolFormDto(
      id: form.id,
      urunKodu: form.urunKodu,
      sarjNo: form.sarjNo,
      paketMiktar: form.paketMiktar,
      hurdaMiktar: form.hurdaMiktar,
      reworkMiktar: form.reworkMiktar,
      aciklama: form.aciklama,
      kayitTarihi: form.kayitTarihi,
    );
    return await _remoteDataSource.create(dto.toJson());
  }

  @override
  Future<void> update(FinalKontrolForm form) async {
    final dto = FinalKontrolFormDto(
      id: form.id,
      urunKodu: form.urunKodu,
      sarjNo: form.sarjNo,
      paketMiktar: form.paketMiktar,
      hurdaMiktar: form.hurdaMiktar,
      reworkMiktar: form.reworkMiktar,
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
