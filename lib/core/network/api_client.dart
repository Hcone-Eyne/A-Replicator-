import 'package:dio/dio.dart';

import 'api_config.dart';

/// Thin wrapper over Dio configured for the Flow App backend.
class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Normalizes a Dio failure into a readable error message.
  static String messageOf(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['detail'] is String) {
        return data['detail'] as String;
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }
}
