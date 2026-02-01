import '../entities/quality_approval_form.dart';
import '../repositories/i_quality_approval_repository.dart';

class SubmitQualityApprovalFormUseCase {
  final IQualityApprovalRepository _repository;

  SubmitQualityApprovalFormUseCase(this._repository);

  Future<int> call(QualityApprovalForm form) {
    return _repository.create(form);
  }
}
