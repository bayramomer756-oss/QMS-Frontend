import 'package:dio/dio.dart';
import '../models/saf_b9_counter_entry_dto.dart';

class SafB9CounterRemoteDataSource {
  final Dio _dio;

  SafB9CounterRemoteDataSource(this._dio);

  Future<List<SafB9CounterEntryDto>> getAll() async {
    final response = await _dio.get('/saf-b9-counter');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map(
          (json) => SafB9CounterEntryDto.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<SafB9CounterEntryDto> getById(int id) async {
    final response = await _dio.get('/saf-b9-counter/$id');
    return SafB9CounterEntryDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<int> create(Map<String, dynamic> data) async {
    final response = await _dio.post('/saf-b9-counter', data: data);
    return response.data['id'] as int;
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    await _dio.put('/saf-b9-counter/$id', data: data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/saf-b9-counter/$id');
  }
}
