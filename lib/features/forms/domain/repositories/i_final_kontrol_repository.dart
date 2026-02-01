import '../entities/final_kontrol_form.dart';

abstract class IFinalKontrolRepository {
  Future<List<FinalKontrolForm>> getAll();
  Future<FinalKontrolForm> getById(int id);
  Future<int> create(FinalKontrolForm form);
  Future<void> update(FinalKontrolForm form);
  Future<void> delete(int id);
}
