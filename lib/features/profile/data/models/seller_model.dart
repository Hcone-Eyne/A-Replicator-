import 'package:freezed_annotation/freezed_annotation.dart';

part 'seller_model.freezed.dart';
part 'seller_model.g.dart';

@freezed
class SellerModel with _$SellerModel {
  const factory SellerModel({
    required String id,
    required String name,
    @Default('') String avatarUrl,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int salesCount,
    @Default(0.0) double positivePercent,
    @Default('') String memberDuration,
    @Default('') String bio,
    @Default(0) int listingsCount,
  }) = _SellerModel;

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);
}
