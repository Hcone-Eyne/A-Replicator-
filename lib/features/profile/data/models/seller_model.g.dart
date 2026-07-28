// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerModelImpl _$$SellerModelImplFromJson(Map<String, dynamic> json) =>
    _$SellerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      salesCount: (json['salesCount'] as num?)?.toInt() ?? 0,
      positivePercent: (json['positivePercent'] as num?)?.toDouble() ?? 0.0,
      memberDuration: json['memberDuration'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      listingsCount: (json['listingsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SellerModelImplToJson(_$SellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'isVerified': instance.isVerified,
      'rating': instance.rating,
      'salesCount': instance.salesCount,
      'positivePercent': instance.positivePercent,
      'memberDuration': instance.memberDuration,
      'bio': instance.bio,
      'listingsCount': instance.listingsCount,
    };
