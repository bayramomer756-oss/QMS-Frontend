import 'package:dio/dio.dart';
import '../models/final_kontrol_form_dto.dart';

class FinalKontrolRemoteDataSource {
  final Dio _dio;

  FinalKontrolRemoteDataSource(this._dio);

  Future<List<FinalKontrolFormDto>> getAll() async {
    final response = await _dio.get('/final-kontrol');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map(
          (json) => FinalKontrolFormDto.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<FinalKontrolFormDto> getById(int id) async {
    final response = await _dio.get('/final-kontrol/$id');
    return FinalKontrolFormDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<int> create(Map<String, dynamic> data) async {
    final response = await _dio.post('/final-kontrol', data: data);
    return response.data['id'] as int;
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    await _dio.put('/final-kontrol/$id', data: data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/final-kontrol/$id');
  }
}
