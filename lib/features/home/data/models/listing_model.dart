import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_model.freezed.dart';
part 'listing_model.g.dart';

enum ListingStatus {
  active,
  reserved,
  sold,
  expired;

  factory ListingStatus.fromString(String value) {
    return switch (value) {
      'active' => ListingStatus.active,
      'reserved' => ListingStatus.reserved,
      'sold' => ListingStatus.sold,
      'expired' => ListingStatus.expired,
      _ => ListingStatus.active,
    };
  }

  String get value => switch (this) {
        ListingStatus.active => 'active',
        ListingStatus.reserved => 'reserved',
        ListingStatus.sold => 'sold',
        ListingStatus.expired => 'expired',
      };
}

@freezed
class ListingModel with _$ListingModel {
  const factory ListingModel({
    required String id,
    required String sellerId,
    @Default('') String title,
    @Default('') String description,
    required double price,
    @Default('NGN') String currency,
    @Default([]) List<String> images,
    required String category,
    @Default('') String subcategory,
    @Default(ListingStatus.active) ListingStatus status,
    required DateTime createdAt,
    @Default(false) bool isFeatured,
    @Default(0) int viewCount,
    @Default(0) int favoriteCount,
    @Default([]) List<String> favoriteBy,
    @Default('') String condition,
    @Default('') String location,
  }) = _ListingModel;

  factory ListingModel.fromJson(Map<String, dynamic> json) =>
      _$ListingModelFromJson(json);
}
