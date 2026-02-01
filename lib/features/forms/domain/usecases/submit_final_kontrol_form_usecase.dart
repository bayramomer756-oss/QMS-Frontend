import '../entities/final_kontrol_form.dart';
import '../repositories/i_final_kontrol_repository.dart';

class SubmitFinalKontrolFormUseCase {
  final IFinalKontrolRepository _repository;

  SubmitFinalKontrolFormUseCase(this._repository);

  Future<int> call(FinalKontrolForm form) {
    return _repository.create(form);
  }
}
