import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/result.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthRemoteRepository extends ApiRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'phone': phone, 'password': password},
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<AuthSession>> signInWithGoogle({required String idToken}) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<AuthSession>> refreshSession({required String refreshToken}) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<UserModel>> getCurrentUser() {
    return guard(() async {
      final response = await ApiClient.dio.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<void>> logout({required String refreshToken}) {
    return guardVoid(
      () => ApiClient.dio.post('/auth/logout', data: {'refreshToken': refreshToken}),
    );
  }

  @override
  Future<Result<void>> verifyEmail({required String code}) {
    return guardVoid(
      () => ApiClient.dio.post(
        '/auth/email-verify/confirm',
        data: {'code': code},
      ),
    );
  }

  @override
  Future<Result<void>> sendEmailVerification() {
    return guardVoid(() => ApiClient.dio.post('/auth/email-verify/send'));
  }

  @override
  Future<Result<void>> verifyOtp({
    required String phone,
    required String otp,
  }) {
    return guardVoid(
      () => ApiClient.dio.post(
        '/auth/otp/verify',
        data: {'phone': phone, 'otp': otp},
      ),
    );
  }

  @override
  Future<Result<void>> sendOtp({required String phone}) {
    return guardVoid(() => ApiClient.dio.post('/auth/otp/send', data: {'phone': phone}));
  }

  @override
  Future<Result<void>> resetPassword({required String email}) {
    return guardVoid(
      () => ApiClient.dio.post(
        '/auth/reset-password',
        data: {'email': email},
      ),
    );
  }

  @override
  Future<Result<void>> completeResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) {
    return guardVoid(
      () => ApiClient.dio.post(
        '/auth/reset-password',
        data: {'email': email, 'token': token, 'newPassword': newPassword},
      ),
    );
  }
}
