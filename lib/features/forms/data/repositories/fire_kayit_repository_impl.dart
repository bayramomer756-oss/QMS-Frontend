import 'dart:io';
import '../../domain/entities/fire_kayit_formu.dart';
import '../../domain/repositories/i_fire_kayit_repository.dart';
import '../datasources/fire_kayit_remote_datasource.dart';

class FireKayitRepositoryImpl implements IFireKayitRepository {
  final FireKayitRemoteDataSource _remoteDataSource;

  FireKayitRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<FireKayitFormu>> getForms({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    // Here we can implement offline caching strategy later
    final dtos = await _remoteDataSource.getForms(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    return dtos; // DTO extends Entity, so this is valid, or we can map if we separate them strictly
  }

  @override
  Future<FireKayitFormu> getForm(int id) async {
    return await _remoteDataSource.getForm(id);
  }

  @override
  Future<int> createForm(Map<String, dynamic> data) async {
    return await _remoteDataSource.createForm(data);
  }

  @override
  Future<void> updateForm(int id, Map<String, dynamic> data) async {
    await _remoteDataSource.updateForm(id, data);
  }

  @override
  Future<void> deleteForm(int id) async {
    await _remoteDataSource.deleteForm(id);
  }

  @override
  Future<String> uploadPhoto(int id, File file) async {
    return await _remoteDataSource.uploadPhoto(id, file);
  }
}
