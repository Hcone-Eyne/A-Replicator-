// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationModelImpl(
      id: json['id'] as String,
      otherUserId: json['otherUserId'] as String,
      otherUserName: json['otherUserName'] as String? ?? '',
      otherUserAvatar: json['otherUserAvatar'] as String? ?? '',
      otherUserInitials: json['otherUserInitials'] as String? ?? '',
      otherUserAvatarColorHex:
          json['otherUserAvatarColorHex'] as String? ?? '#2196F3',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      productTitle: json['productTitle'] as String? ?? '',
      productImage: json['productImage'] as String? ?? '',
    );

Map<String, dynamic> _$$ConversationModelImplToJson(
        _$ConversationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'otherUserId': instance.otherUserId,
      'otherUserName': instance.otherUserName,
      'otherUserAvatar': instance.otherUserAvatar,
      'otherUserInitials': instance.otherUserInitials,
      'otherUserAvatarColorHex': instance.otherUserAvatarColorHex,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'isOnline': instance.isOnline,
      'isVerified': instance.isVerified,
      'productTitle': instance.productTitle,
      'productImage': instance.productImage,
    };
