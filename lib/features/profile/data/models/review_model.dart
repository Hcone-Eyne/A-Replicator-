import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String sellerId,
    required String userName,
    @Default('') String userAvatar,
    required int rating,
    required DateTime date,
    @Default('') String text,
    @Default(false) bool hasPhoto,
    @Default('') String photoUrl,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}
