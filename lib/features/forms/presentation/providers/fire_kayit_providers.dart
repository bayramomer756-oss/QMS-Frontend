import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/fire_kayit_remote_datasource.dart';
import '../../data/repositories/fire_kayit_repository_impl.dart';
import '../../domain/repositories/i_fire_kayit_repository.dart';
import '../../domain/usecases/create_fire_kayit_form_usecase.dart';
import '../../domain/usecases/get_fire_kayit_forms_usecase.dart';

// DataSource Provider
final fireKayitRemoteDataSourceProvider = Provider<FireKayitRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioClientProvider);
  return FireKayitRemoteDataSource(dio);
});

// Repository Provider
final fireKayitRepositoryProvider = Provider<IFireKayitRepository>((ref) {
  final dataSource = ref.watch(fireKayitRemoteDataSourceProvider);
  return FireKayitRepositoryImpl(dataSource);
});

// UseCase Providers
final getFireKayitFormsUseCaseProvider = Provider<GetFireKayitFormsUseCase>((
  ref,
) {
  final repository = ref.watch(fireKayitRepositoryProvider);
  return GetFireKayitFormsUseCase(repository);
});

final createFireKayitFormUseCaseProvider = Provider<CreateFireKayitFormUseCase>(
  (ref) {
    final repository = ref.watch(fireKayitRepositoryProvider);
    return CreateFireKayitFormUseCase(repository);
  },
);
