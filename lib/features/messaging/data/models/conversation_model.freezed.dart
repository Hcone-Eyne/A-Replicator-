// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String get id => throw _privateConstructorUsedError;
  String get otherUserId => throw _privateConstructorUsedError;
  String get otherUserName => throw _privateConstructorUsedError;
  String get otherUserAvatar => throw _privateConstructorUsedError;
  String get otherUserInitials => throw _privateConstructorUsedError;
  String get otherUserAvatarColorHex => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  DateTime get lastMessageTime => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get productTitle => throw _privateConstructorUsedError;
  String get productImage => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
          ConversationModel value, $Res Function(ConversationModel) then) =
      _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call(
      {String id,
      String otherUserId,
      String otherUserName,
      String otherUserAvatar,
      String otherUserInitials,
      String otherUserAvatarColorHex,
      String lastMessage,
      DateTime lastMessageTime,
      int unreadCount,
      bool isOnline,
      bool isVerified,
      String productTitle,
      String productImage});
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? otherUserId = null,
    Object? otherUserName = null,
    Object? otherUserAvatar = null,
    Object? otherUserInitials = null,
    Object? otherUserAvatarColorHex = null,
    Object? lastMessage = null,
    Object? lastMessageTime = null,
    Object? unreadCount = null,
    Object? isOnline = null,
    Object? isVerified = null,
    Object? productTitle = null,
    Object? productImage = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserId: null == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserName: null == otherUserName
          ? _value.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatar: null == otherUserAvatar
          ? _value.otherUserAvatar
          : otherUserAvatar // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserInitials: null == otherUserInitials
          ? _value.otherUserInitials
          : otherUserInitials // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatarColorHex: null == otherUserAvatarColorHex
          ? _value.otherUserAvatarColorHex
          : otherUserAvatarColorHex // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTime: null == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      productTitle: null == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(_$ConversationModelImpl value,
          $Res Function(_$ConversationModelImpl) then) =
      __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String otherUserId,
      String otherUserName,
      String otherUserAvatar,
      String otherUserInitials,
      String otherUserAvatarColorHex,
      String lastMessage,
      DateTime lastMessageTime,
      int unreadCount,
      bool isOnline,
      bool isVerified,
      String productTitle,
      String productImage});
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(_$ConversationModelImpl _value,
      $Res Function(_$ConversationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? otherUserId = null,
    Object? otherUserName = null,
    Object? otherUserAvatar = null,
    Object? otherUserInitials = null,
    Object? otherUserAvatarColorHex = null,
    Object? lastMessage = null,
    Object? lastMessageTime = null,
    Object? unreadCount = null,
    Object? isOnline = null,
    Object? isVerified = null,
    Object? productTitle = null,
    Object? productImage = null,
  }) {
    return _then(_$ConversationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserId: null == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserName: null == otherUserName
          ? _value.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatar: null == otherUserAvatar
          ? _value.otherUserAvatar
          : otherUserAvatar // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserInitials: null == otherUserInitials
          ? _value.otherUserInitials
          : otherUserInitials // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatarColorHex: null == otherUserAvatarColorHex
          ? _value.otherUserAvatarColorHex
          : otherUserAvatarColorHex // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTime: null == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      productTitle: null == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl implements _ConversationModel {
  const _$ConversationModelImpl(
      {required this.id,
      required this.otherUserId,
      this.otherUserName = '',
      this.otherUserAvatar = '',
      this.otherUserInitials = '',
      this.otherUserAvatarColorHex = '#2196F3',
      this.lastMessage = '',
      required this.lastMessageTime,
      this.unreadCount = 0,
      this.isOnline = false,
      this.isVerified = false,
      this.productTitle = '',
      this.productImage = ''});

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String otherUserId;
  @override
  @JsonKey()
  final String otherUserName;
  @override
  @JsonKey()
  final String otherUserAvatar;
  @override
  @JsonKey()
  final String otherUserInitials;
  @override
  @JsonKey()
  final String otherUserAvatarColorHex;
  @override
  @JsonKey()
  final String lastMessage;
  @override
  final DateTime lastMessageTime;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final String productTitle;
  @override
  @JsonKey()
  final String productImage;

  @override
  String toString() {
    return 'ConversationModel(id: $id, otherUserId: $otherUserId, otherUserName: $otherUserName, otherUserAvatar: $otherUserAvatar, otherUserInitials: $otherUserInitials, otherUserAvatarColorHex: $otherUserAvatarColorHex, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, unreadCount: $unreadCount, isOnline: $isOnline, isVerified: $isVerified, productTitle: $productTitle, productImage: $productImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherUserName, otherUserName) ||
                other.otherUserName == otherUserName) &&
            (identical(other.otherUserAvatar, otherUserAvatar) ||
                other.otherUserAvatar == otherUserAvatar) &&
            (identical(other.otherUserInitials, otherUserInitials) ||
                other.otherUserInitials == otherUserInitials) &&
            (identical(
                    other.otherUserAvatarColorHex, otherUserAvatarColorHex) ||
                other.otherUserAvatarColorHex == otherUserAvatarColorHex) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.productTitle, productTitle) ||
                other.productTitle == productTitle) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      otherUserId,
      otherUserName,
      otherUserAvatar,
      otherUserInitials,
      otherUserAvatarColorHex,
      lastMessage,
      lastMessageTime,
      unreadCount,
      isOnline,
      isVerified,
      productTitle,
      productImage);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(
      this,
    );
  }
}

abstract class _ConversationModel implements ConversationModel {
  const factory _ConversationModel(
      {required final String id,
      required final String otherUserId,
      final String otherUserName,
      final String otherUserAvatar,
      final String otherUserInitials,
      final String otherUserAvatarColorHex,
      final String lastMessage,
      required final DateTime lastMessageTime,
      final int unreadCount,
      final bool isOnline,
      final bool isVerified,
      final String productTitle,
      final String productImage}) = _$ConversationModelImpl;

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get otherUserId;
  @override
  String get otherUserName;
  @override
  String get otherUserAvatar;
  @override
  String get otherUserInitials;
  @override
  String get otherUserAvatarColorHex;
  @override
  String get lastMessage;
  @override
  DateTime get lastMessageTime;
  @override
  int get unreadCount;
  @override
  bool get isOnline;
  @override
  bool get isVerified;
  @override
  String get productTitle;
  @override
  String get productImage;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
