import '../models/notification_model.dart';
import '../../../../shared/models/result.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<Result<void>> markAsRead({
    required String id,
  });

  Future<Result<void>> markAllAsRead();

  Future<Result<int>> getUnreadCount();
}

class MockNotificationRepository implements NotificationRepository {
  static final _mockNotifications = <String, NotificationModel>{
    'notif_001': NotificationModel(
      id: 'notif_001',
      title: 'Order Shipped',
      body: 'Your order #FLW-001 has been shipped.',
      type: NotificationType.order,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      data: {'orderId': 'ord_001'},
    ),
    'notif_002': NotificationModel(
      id: 'notif_002',
      title: 'New Message',
      body: 'Maria Lopez sent you a message.',
      type: NotificationType.message,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      data: {'conversationId': 'conv_001'},
    ),
    'notif_003': NotificationModel(
      id: 'notif_003',
      title: 'Payment Received',
      body: 'Payment of \$18,500 confirmed for order #FLW-001.',
      type: NotificationType.order,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      data: {'orderId': 'ord_001'},
    ),
    'notif_004': NotificationModel(
      id: 'notif_004',
      title: 'Weekend Sale',
      body: 'Up to 40% off on electronics. Don\'t miss out!',
      type: NotificationType.promotion,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    'notif_005': NotificationModel(
      id: 'notif_005',
      title: 'Account Verified',
      body: 'Your account has been successfully verified.',
      type: NotificationType.system,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    'notif_006': NotificationModel(
      id: 'notif_006',
      title: 'New Message',
      body: 'Ana Garcia sent you a message.',
      type: NotificationType.message,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      data: {'conversationId': 'conv_003'},
    ),
  };

  @override
  Future<Result<List<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final sorted = _mockNotifications.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = sorted.sublist(start, end.clamp(0, sorted.length));
    return Success(paged);
  }

  @override
  Future<Result<void>> markAsRead({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final notif = _mockNotifications[id];
    if (notif == null) return const Error('Notification not found');
    _mockNotifications[id] = notif.copyWith(isRead: true);
    return const Success(null);
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));

    for (final entry in _mockNotifications.entries) {
      _mockNotifications[entry.key] = entry.value.copyWith(isRead: true);
    }
    return const Success(null);
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final count = _mockNotifications.values.where((n) => !n.isRead).length;
    return Success(count);
  }
}
