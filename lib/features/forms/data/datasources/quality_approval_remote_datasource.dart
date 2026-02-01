import 'package:dio/dio.dart';
import '../models/quality_approval_form_dto.dart';

class QualityApprovalRemoteDataSource {
  final Dio _dio;

  QualityApprovalRemoteDataSource(this._dio);

  Future<List<QualityApprovalFormDto>> getAll() async {
    final response = await _dio.get('/kalite-onay');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map(
          (json) =>
              QualityApprovalFormDto.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<QualityApprovalFormDto> getById(int id) async {
    final response = await _dio.get('/kalite-onay/$id');
    return QualityApprovalFormDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<int> create(Map<String, dynamic> data) async {
    final response = await _dio.post('/kalite-onay', data: data);
    return response.data['id'] as int;
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    await _dio.put('/kalite-onay/$id', data: data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/kalite-onay/$id');
  }
}
