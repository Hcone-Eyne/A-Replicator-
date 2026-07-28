// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListingModel _$ListingModelFromJson(Map<String, dynamic> json) {
  return _ListingModel.fromJson(json);
}

/// @nodoc
mixin _$ListingModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get subcategory => throw _privateConstructorUsedError;
  ListingStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get favoriteCount => throw _privateConstructorUsedError;
  List<String> get favoriteBy => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;

  /// Serializes this ListingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingModelCopyWith<ListingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingModelCopyWith<$Res> {
  factory $ListingModelCopyWith(
          ListingModel value, $Res Function(ListingModel) then) =
      _$ListingModelCopyWithImpl<$Res, ListingModel>;
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String title,
      String description,
      double price,
      String currency,
      List<String> images,
      String category,
      String subcategory,
      ListingStatus status,
      DateTime createdAt,
      bool isFeatured,
      int viewCount,
      int favoriteCount,
      List<String> favoriteBy,
      String condition,
      String location});
}

/// @nodoc
class _$ListingModelCopyWithImpl<$Res, $Val extends ListingModel>
    implements $ListingModelCopyWith<$Res> {
  _$ListingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? images = null,
    Object? category = null,
    Object? subcategory = null,
    Object? status = null,
    Object? createdAt = null,
    Object? isFeatured = null,
    Object? viewCount = null,
    Object? favoriteCount = null,
    Object? favoriteBy = null,
    Object? condition = null,
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subcategory: null == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ListingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteBy: null == favoriteBy
          ? _value.favoriteBy
          : favoriteBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingModelImplCopyWith<$Res>
    implements $ListingModelCopyWith<$Res> {
  factory _$$ListingModelImplCopyWith(
          _$ListingModelImpl value, $Res Function(_$ListingModelImpl) then) =
      __$$ListingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String title,
      String description,
      double price,
      String currency,
      List<String> images,
      String category,
      String subcategory,
      ListingStatus status,
      DateTime createdAt,
      bool isFeatured,
      int viewCount,
      int favoriteCount,
      List<String> favoriteBy,
      String condition,
      String location});
}

/// @nodoc
class __$$ListingModelImplCopyWithImpl<$Res>
    extends _$ListingModelCopyWithImpl<$Res, _$ListingModelImpl>
    implements _$$ListingModelImplCopyWith<$Res> {
  __$$ListingModelImplCopyWithImpl(
      _$ListingModelImpl _value, $Res Function(_$ListingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? images = null,
    Object? category = null,
    Object? subcategory = null,
    Object? status = null,
    Object? createdAt = null,
    Object? isFeatured = null,
    Object? viewCount = null,
    Object? favoriteCount = null,
    Object? favoriteBy = null,
    Object? condition = null,
    Object? location = null,
  }) {
    return _then(_$ListingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subcategory: null == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ListingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteBy: null == favoriteBy
          ? _value._favoriteBy
          : favoriteBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingModelImpl implements _ListingModel {
  const _$ListingModelImpl(
      {required this.id,
      required this.sellerId,
      this.title = '',
      this.description = '',
      required this.price,
      this.currency = 'NGN',
      final List<String> images = const [],
      required this.category,
      this.subcategory = '',
      this.status = ListingStatus.active,
      required this.createdAt,
      this.isFeatured = false,
      this.viewCount = 0,
      this.favoriteCount = 0,
      final List<String> favoriteBy = const [],
      this.condition = '',
      this.location = ''})
      : _images = images,
        _favoriteBy = favoriteBy;

  factory _$ListingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String category;
  @override
  @JsonKey()
  final String subcategory;
  @override
  @JsonKey()
  final ListingStatus status;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int viewCount;
  @override
  @JsonKey()
  final int favoriteCount;
  final List<String> _favoriteBy;
  @override
  @JsonKey()
  List<String> get favoriteBy {
    if (_favoriteBy is EqualUnmodifiableListView) return _favoriteBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteBy);
  }

  @override
  @JsonKey()
  final String condition;
  @override
  @JsonKey()
  final String location;

  @override
  String toString() {
    return 'ListingModel(id: $id, sellerId: $sellerId, title: $title, description: $description, price: $price, currency: $currency, images: $images, category: $category, subcategory: $subcategory, status: $status, createdAt: $createdAt, isFeatured: $isFeatured, viewCount: $viewCount, favoriteCount: $favoriteCount, favoriteBy: $favoriteBy, condition: $condition, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subcategory, subcategory) ||
                other.subcategory == subcategory) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.favoriteCount, favoriteCount) ||
                other.favoriteCount == favoriteCount) &&
            const DeepCollectionEquality()
                .equals(other._favoriteBy, _favoriteBy) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sellerId,
      title,
      description,
      price,
      currency,
      const DeepCollectionEquality().hash(_images),
      category,
      subcategory,
      status,
      createdAt,
      isFeatured,
      viewCount,
      favoriteCount,
      const DeepCollectionEquality().hash(_favoriteBy),
      condition,
      location);

  /// Create a copy of ListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingModelImplCopyWith<_$ListingModelImpl> get copyWith =>
      __$$ListingModelImplCopyWithImpl<_$ListingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingModelImplToJson(
      this,
    );
  }
}

abstract class _ListingModel implements ListingModel {
  const factory _ListingModel(
      {required final String id,
      required final String sellerId,
      final String title,
      final String description,
      required final double price,
      final String currency,
      final List<String> images,
      required final String category,
      final String subcategory,
      final ListingStatus status,
      required final DateTime createdAt,
      final bool isFeatured,
      final int viewCount,
      final int favoriteCount,
      final List<String> favoriteBy,
      final String condition,
      final String location}) = _$ListingModelImpl;

  factory _ListingModel.fromJson(Map<String, dynamic> json) =
      _$ListingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  List<String> get images;
  @override
  String get category;
  @override
  String get subcategory;
  @override
  ListingStatus get status;
  @override
  DateTime get createdAt;
  @override
  bool get isFeatured;
  @override
  int get viewCount;
  @override
  int get favoriteCount;
  @override
  List<String> get favoriteBy;
  @override
  String get condition;
  @override
  String get location;

  /// Create a copy of ListingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingModelImplCopyWith<_$ListingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
