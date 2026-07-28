import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required String icon,
    @Default(0) int count,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

extension CategoryModelX on CategoryModel {
  IconData get iconData {
    return switch (icon) {
      'car' => Icons.directions_car,
      'phone' => Icons.phone_iphone,
      'laptop' => Icons.laptop,
      'home' => Icons.home,
      'fashion' => Icons.checkroom,
      'sports' => Icons.sports_soccer,
      'toys' => Icons.toys,
      'pets' => Icons.pets,
      'books' => Icons.menu_book,
      'music' => Icons.music_note,
      'photo' => Icons.camera_alt,
      'tools' => Icons.build,
      'garden' => Icons.yard,
      'baby' => Icons.child_care,
      'health' => Icons.favorite,
      'grocery' => Icons.shopping_cart,
      'other' => Icons.more_horiz,
      _ => Icons.category,
    };
  }
}
