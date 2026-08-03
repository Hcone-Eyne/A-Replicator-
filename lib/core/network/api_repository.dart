import 'package:dio/dio.dart';

import '../../../shared/models/pagination.dart';
import '../../../shared/models/result.dart';
import 'api_client.dart';

/// Shared helpers for the remote repository implementations.
abstract class ApiRepository {
  /// Wraps an API call in a [Result], converting Dio failures to [Error].
  Future<Result<T>> guard<T>(Future<T> Function() run) async {
    try {
      return Success(await run());
    } on DioException catch (e) {
      return Error(ApiClient.messageOf(e));
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  /// Wraps an API call whose response payload is ignored.
  Future<Result<void>> guardVoid(Future<dynamic> Function() run) async {
    try {
      await run();
      return const Success(null);
    } on DioException catch (e) {
      return Error(ApiClient.messageOf(e));
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  /// Parses the backend pagination envelope into [Pagination].
  Pagination<T> parsePagination<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return Pagination<T>(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}
