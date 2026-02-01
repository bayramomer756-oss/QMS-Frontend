import '../entities/saf_b9_counter_entry.dart';
import '../repositories/i_saf_b9_counter_repository.dart';

class GetSafB9CounterEntriesUseCase {
  final ISafB9CounterRepository _repository;

  GetSafB9CounterEntriesUseCase(this._repository);

  Future<List<SafB9CounterEntry>> call() {
    return _repository.getAll();
  }
}
