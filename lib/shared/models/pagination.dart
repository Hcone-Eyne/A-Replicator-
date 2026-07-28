import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';

@freezed
class Pagination<T> with _$Pagination<T> {
  const factory Pagination({
    @Default([]) List<T> items,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(0) int totalItems,
    @Default(false) bool hasMore,
  }) = _Pagination<T>;
}
