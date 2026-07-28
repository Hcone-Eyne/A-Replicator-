import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required String otherUserId,
    @Default('') String otherUserName,
    @Default('') String otherUserAvatar,
    @Default('') String otherUserInitials,
    @Default('#2196F3') String otherUserAvatarColorHex,
    @Default('') String lastMessage,
    required DateTime lastMessageTime,
    @Default(0) int unreadCount,
    @Default(false) bool isOnline,
    @Default(false) bool isVerified,
    @Default('') String productTitle,
    @Default('') String productImage,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}
