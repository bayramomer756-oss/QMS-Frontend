import '../../domain/entities/saf_b9_counter_entry.dart';
import '../../domain/repositories/i_saf_b9_counter_repository.dart';
import '../datasources/saf_b9_counter_remote_datasource.dart';
import '../models/saf_b9_counter_entry_dto.dart';

class SafB9CounterRepositoryImpl implements ISafB9CounterRepository {
  final SafB9CounterRemoteDataSource _remoteDataSource;

  SafB9CounterRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SafB9CounterEntry>> getAll() async {
    final dtos = await _remoteDataSource.getAll();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<SafB9CounterEntry> getById(int id) async {
    final dto = await _remoteDataSource.getById(id);
    return dto.toEntity();
  }

  @override
  Future<int> create(SafB9CounterEntry entry) async {
    final dto = SafB9CounterEntryDto(
      id: entry.id,
      urunKodu: entry.urunKodu,
      urunAdi: entry.urunAdi,
      duzceCount: entry.duzceCount,
      almanyaCount: entry.almanyaCount,
      hurdaCount: entry.hurdaCount,
      retNedeni: entry.retNedeni,
      kayitTarihi: entry.kayitTarihi,
    );
    return await _remoteDataSource.create(dto.toJson());
  }

  @override
  Future<void> update(SafB9CounterEntry entry) async {
    final dto = SafB9CounterEntryDto(
      id: entry.id,
      urunKodu: entry.urunKodu,
      urunAdi: entry.urunAdi,
      duzceCount: entry.duzceCount,
      almanyaCount: entry.almanyaCount,
      hurdaCount: entry.hurdaCount,
      retNedeni: entry.retNedeni,
      kayitTarihi: entry.kayitTarihi,
    );
    await _remoteDataSource.update(entry.id!, dto.toJson());
  }

  @override
  Future<void> delete(int id) async {
    await _remoteDataSource.delete(id);
  }
}
