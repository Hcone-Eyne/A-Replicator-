// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      listingsCount: (json['listingsCount'] as num?)?.toInt() ?? 0,
      salesCount: (json['salesCount'] as num?)?.toInt() ?? 0,
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFollowing: json['isFollowing'] as bool? ?? false,
      listingIds: (json['listingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      wishlistIds: (json['wishlistIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'isVerified': instance.isVerified,
      'location': instance.location,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'listingsCount': instance.listingsCount,
      'salesCount': instance.salesCount,
      'followers': instance.followers,
      'following': instance.following,
      'isFollowing': instance.isFollowing,
      'listingIds': instance.listingIds,
      'wishlistIds': instance.wishlistIds,
    };
