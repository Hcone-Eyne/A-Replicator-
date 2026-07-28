// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String? ?? '',
      rating: (json['rating'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String? ?? '',
      hasPhoto: json['hasPhoto'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'rating': instance.rating,
      'date': instance.date.toIso8601String(),
      'text': instance.text,
      'hasPhoto': instance.hasPhoto,
      'photoUrl': instance.photoUrl,
    };
