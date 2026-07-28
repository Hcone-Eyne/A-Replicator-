import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  order,
  message,
  system,
  promotion;

  factory NotificationType.fromString(String value) {
    return switch (value) {
      'order' => NotificationType.order,
      'message' => NotificationType.message,
      'system' => NotificationType.system,
      'promotion' => NotificationType.promotion,
      _ => NotificationType.system,
    };
  }

  String get value => switch (this) {
        NotificationType.order => 'order',
        NotificationType.message => 'message',
        NotificationType.system => 'system',
        NotificationType.promotion => 'promotion',
      };
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @Default('') String title,
    @Default('') String body,
    @Default(NotificationType.system) NotificationType type,
    @Default(false) bool isRead,
    required DateTime createdAt,
    @Default({}) Map<String, dynamic> data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
