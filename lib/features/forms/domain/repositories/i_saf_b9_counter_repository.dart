import '../entities/saf_b9_counter_entry.dart';

abstract class ISafB9CounterRepository {
  Future<List<SafB9CounterEntry>> getAll();
  Future<SafB9CounterEntry> getById(int id);
  Future<int> create(SafB9CounterEntry entry);
  Future<void> update(SafB9CounterEntry entry);
  Future<void> delete(int id);
}
