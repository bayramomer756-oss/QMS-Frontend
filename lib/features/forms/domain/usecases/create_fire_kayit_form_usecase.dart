import '../repositories/i_fire_kayit_repository.dart';

class CreateFireKayitFormUseCase {
  final IFireKayitRepository _repository;

  CreateFireKayitFormUseCase(this._repository);

  Future<int> call(Map<String, dynamic> data) {
    return _repository.createForm(data);
  }
}
