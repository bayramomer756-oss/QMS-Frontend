import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../database/database.dart';
import '../sync/sync_service.dart';

part 'app_providers.g.dart';

/// Database provider
@riverpod
AppDatabase database(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

/// Dio HTTP client provider
@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://your-api-url.com', // TODO: Update with actual API URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Add interceptors
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[DIO] $obj'),
    ),
  );

  return dio;
}

/// Sync Service provider
@riverpod
SyncService syncService(Ref ref) {
  final db = ref.watch(databaseProvider);
  final dio = ref.watch(dioProvider);

  return SyncService(database: db, dio: dio);
}
