// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  int get listingsCount => throw _privateConstructorUsedError;
  int get salesCount => throw _privateConstructorUsedError;
  List<String> get followers => throw _privateConstructorUsedError;
  List<String> get following => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  List<String> get listingIds => throw _privateConstructorUsedError;
  List<String> get wishlistIds => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String phone,
      String avatarUrl,
      bool isVerified,
      String location,
      double rating,
      int reviewsCount,
      int listingsCount,
      int salesCount,
      List<String> followers,
      List<String> following,
      bool isFollowing,
      List<String> listingIds,
      List<String> wishlistIds});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatarUrl = null,
    Object? isVerified = null,
    Object? location = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? listingsCount = null,
    Object? salesCount = null,
    Object? followers = null,
    Object? following = null,
    Object? isFollowing = null,
    Object? listingIds = null,
    Object? wishlistIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      listingsCount: null == listingsCount
          ? _value.listingsCount
          : listingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      salesCount: null == salesCount
          ? _value.salesCount
          : salesCount // ignore: cast_nullable_to_non_nullable
              as int,
      followers: null == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      following: null == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      listingIds: null == listingIds
          ? _value.listingIds
          : listingIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wishlistIds: null == wishlistIds
          ? _value.wishlistIds
          : wishlistIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String phone,
      String avatarUrl,
      bool isVerified,
      String location,
      double rating,
      int reviewsCount,
      int listingsCount,
      int salesCount,
      List<String> followers,
      List<String> following,
      bool isFollowing,
      List<String> listingIds,
      List<String> wishlistIds});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatarUrl = null,
    Object? isVerified = null,
    Object? location = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? listingsCount = null,
    Object? salesCount = null,
    Object? followers = null,
    Object? following = null,
    Object? isFollowing = null,
    Object? listingIds = null,
    Object? wishlistIds = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      listingsCount: null == listingsCount
          ? _value.listingsCount
          : listingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      salesCount: null == salesCount
          ? _value.salesCount
          : salesCount // ignore: cast_nullable_to_non_nullable
              as int,
      followers: null == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      following: null == following
          ? _value._following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      listingIds: null == listingIds
          ? _value._listingIds
          : listingIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wishlistIds: null == wishlistIds
          ? _value._wishlistIds
          : wishlistIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.name,
      this.email = '',
      this.phone = '',
      this.avatarUrl = '',
      this.isVerified = false,
      this.location = '',
      this.rating = 0.0,
      this.reviewsCount = 0,
      this.listingsCount = 0,
      this.salesCount = 0,
      final List<String> followers = const [],
      final List<String> following = const [],
      this.isFollowing = false,
      final List<String> listingIds = const [],
      final List<String> wishlistIds = const []})
      : _followers = followers,
        _following = following,
        _listingIds = listingIds,
        _wishlistIds = wishlistIds;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String avatarUrl;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewsCount;
  @override
  @JsonKey()
  final int listingsCount;
  @override
  @JsonKey()
  final int salesCount;
  final List<String> _followers;
  @override
  @JsonKey()
  List<String> get followers {
    if (_followers is EqualUnmodifiableListView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followers);
  }

  final List<String> _following;
  @override
  @JsonKey()
  List<String> get following {
    if (_following is EqualUnmodifiableListView) return _following;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_following);
  }

  @override
  @JsonKey()
  final bool isFollowing;
  final List<String> _listingIds;
  @override
  @JsonKey()
  List<String> get listingIds {
    if (_listingIds is EqualUnmodifiableListView) return _listingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listingIds);
  }

  final List<String> _wishlistIds;
  @override
  @JsonKey()
  List<String> get wishlistIds {
    if (_wishlistIds is EqualUnmodifiableListView) return _wishlistIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wishlistIds);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, isVerified: $isVerified, location: $location, rating: $rating, reviewsCount: $reviewsCount, listingsCount: $listingsCount, salesCount: $salesCount, followers: $followers, following: $following, isFollowing: $isFollowing, listingIds: $listingIds, wishlistIds: $wishlistIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.listingsCount, listingsCount) ||
                other.listingsCount == listingsCount) &&
            (identical(other.salesCount, salesCount) ||
                other.salesCount == salesCount) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality()
                .equals(other._following, _following) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            const DeepCollectionEquality()
                .equals(other._listingIds, _listingIds) &&
            const DeepCollectionEquality()
                .equals(other._wishlistIds, _wishlistIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      phone,
      avatarUrl,
      isVerified,
      location,
      rating,
      reviewsCount,
      listingsCount,
      salesCount,
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_following),
      isFollowing,
      const DeepCollectionEquality().hash(_listingIds),
      const DeepCollectionEquality().hash(_wishlistIds));

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String name,
      final String email,
      final String phone,
      final String avatarUrl,
      final bool isVerified,
      final String location,
      final double rating,
      final int reviewsCount,
      final int listingsCount,
      final int salesCount,
      final List<String> followers,
      final List<String> following,
      final bool isFollowing,
      final List<String> listingIds,
      final List<String> wishlistIds}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get avatarUrl;
  @override
  bool get isVerified;
  @override
  String get location;
  @override
  double get rating;
  @override
  int get reviewsCount;
  @override
  int get listingsCount;
  @override
  int get salesCount;
  @override
  List<String> get followers;
  @override
  List<String> get following;
  @override
  bool get isFollowing;
  @override
  List<String> get listingIds;
  @override
  List<String> get wishlistIds;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
