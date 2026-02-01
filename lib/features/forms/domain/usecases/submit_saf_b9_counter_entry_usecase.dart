import '../entities/saf_b9_counter_entry.dart';
import '../repositories/i_saf_b9_counter_repository.dart';

class SubmitSafB9CounterEntryUseCase {
  final ISafB9CounterRepository _repository;

  SubmitSafB9CounterEntryUseCase(this._repository);

  Future<int> call(SafB9CounterEntry entry) {
    return _repository.create(entry);
  }
}
