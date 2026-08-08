import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    @Default('bearer') String tokenType,
    @Default(0) int expiresIn,
    @Default(false) bool isVerificationRequired,
    @Default(UserModel(id: '', name: '')) UserModel user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
