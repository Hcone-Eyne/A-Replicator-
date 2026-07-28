// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingModelImpl _$$ListingModelImplFromJson(Map<String, dynamic> json) =>
    _$ListingModelImpl(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'NGN',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String,
      subcategory: json['subcategory'] as String? ?? '',
      status: $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
          ListingStatus.active,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
      favoriteBy: (json['favoriteBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      condition: json['condition'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );

Map<String, dynamic> _$$ListingModelImplToJson(_$ListingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'images': instance.images,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'status': _$ListingStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isFeatured': instance.isFeatured,
      'viewCount': instance.viewCount,
      'favoriteCount': instance.favoriteCount,
      'favoriteBy': instance.favoriteBy,
      'condition': instance.condition,
      'location': instance.location,
    };

const _$ListingStatusEnumMap = {
  ListingStatus.active: 'active',
  ListingStatus.reserved: 'reserved',
  ListingStatus.sold: 'sold',
  ListingStatus.expired: 'expired',
};
