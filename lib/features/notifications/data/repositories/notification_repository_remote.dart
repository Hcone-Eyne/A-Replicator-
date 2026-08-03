import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/result.dart';
import '../../data/models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationRemoteRepository extends ApiRepository
    implements NotificationRepository {
  @override
  Future<Result<List<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/notifications',
        queryParameters: {'page': page, 'limit': limit},
      );
      final pagination = parsePagination(
        response.data as Map<String, dynamic>,
        NotificationModel.fromJson,
      );
      return pagination.items;
    });
  }

  @override
  Future<Result<void>> markAsRead({required String id}) {
    return guardVoid(() => ApiClient.dio.post('/notifications/$id/read'));
  }

  @override
  Future<Result<void>> markAllAsRead() {
    return guardVoid(() => ApiClient.dio.post('/notifications/read-all'));
  }

  @override
  Future<Result<int>> getUnreadCount() {
    return guard(() async {
      final response = await ApiClient.dio.get('/notifications/unread-count');
      return (response.data as Map<String, dynamic>)['count'] as int;
    });
  }
}
