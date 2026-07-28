import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationState {
  final AsyncValue<List<NotificationModel>> notifications;
  final int unreadCount;

  const NotificationState({
    this.notifications = const AsyncValue.data([]),
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    AsyncValue<List<NotificationModel>>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> getNotifications() async {
    state = state.copyWith(notifications: const AsyncValue.loading());
    final result = await _repository.getNotifications();
    if (result.isSuccess) {
      final list = result.data!;
      final unreadCount = list.where((n) => !n.isRead).length;
      state = state.copyWith(
        notifications: AsyncValue.data(list),
        unreadCount: unreadCount,
      );
    } else {
      state = state.copyWith(
        notifications: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(id: notificationId);
    final current = state.notifications.valueOrNull ?? [];
    final updated = current.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    final unreadCount = updated.where((n) => !n.isRead).length;
    state = state.copyWith(
      notifications: AsyncValue.data(updated),
      unreadCount: unreadCount,
    );
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    final current = state.notifications.valueOrNull ?? [];
    final updated = current.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(
      notifications: AsyncValue.data(updated),
      unreadCount: 0,
    );
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository();
});

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});
