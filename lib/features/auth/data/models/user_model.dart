import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String avatarUrl,
    @Default(false) bool isVerified,
    @Default('') String location,
    @Default(0.0) double rating,
    @Default(0) int reviewsCount,
    @Default(0) int listingsCount,
    @Default(0) int salesCount,
    @Default([]) List<String> followers,
    @Default([]) List<String> following,
    @Default(false) bool isFollowing,
    @Default([]) List<String> listingIds,
    @Default([]) List<String> wishlistIds,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
