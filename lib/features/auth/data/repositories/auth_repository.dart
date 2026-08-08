import '../../data/models/auth_session.dart';
import '../../data/models/user_model.dart';
import '../../../../shared/models/result.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Result<AuthSession>> signInWithGoogle({required String idToken});

  Future<Result<AuthSession>> refreshSession({required String refreshToken});

  Future<Result<UserModel>> getCurrentUser();

  Future<Result<void>> logout({required String refreshToken});

  Future<Result<void>> verifyEmail({required String code});

  Future<Result<void>> sendEmailVerification();

  Future<Result<void>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<Result<void>> sendOtp({
    required String phone,
  });

  /// Sends a password reset code to [email].
  Future<Result<void>> resetPassword({required String email});

  /// Redeems [token] with [newPassword] to finish the reset flow.
  Future<Result<void>> completeResetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
}

class MockAuthRepository implements AuthRepository {
  static const _mockUser = UserModel(
    id: 'user_001',
    name: 'Carlos Mendoza',
    email: 'carlos@example.com',
    phone: '+52 55 1234 5678',
    avatarUrl: '',
    location: 'Ciudad de Mexico, Mexico',
    isVerified: true,
    listingsCount: 12,
    salesCount: 48,
    followers: ['user_002', 'user_003', 'user_004'],
    following: ['user_005', 'user_006'],
    listingIds: ['list_010', 'list_011'],
    wishlistIds: ['list_020'],
  );

  static final _mockUsers = <String, UserModel>{
    'user_001': _mockUser,
    'carlos@example.com': _mockUser,
  };

  /// Resolves a mock session. Username is derived from the email local-part
  /// so `mock@example.com` is also reachable as `mock`.
  AuthSession _sessionFor(UserModel user) {
    final username = user.email.split('@').first;
    _mockUsers[username] = user;
    return AuthSession(
      accessToken: 'mock_access_${user.id}',
      refreshToken: 'mock_refresh_${user.id}',
      expiresIn: 3600,
      isVerificationRequired: !user.isVerified,
      user: user,
    );
  }

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _mockUsers[email.trim()] ?? _mockUsers[email.trim().split('@').first];
    if (user != null && password.length >= 6) {
      return Success(_sessionFor(user));
    }
    return const Error('Invalid email or password');
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final trimmed = email.trim();
    if (_mockUsers.containsKey(trimmed)) {
      return const Error('Email already registered');
    }
    if (password.length < 6) {
      return const Error('Password must be at least 6 characters');
    }

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: trimmed,
      phone: phone,
    );
    _mockUsers[trimmed] = newUser;
    _mockUsers[newUser.id] = newUser;
    return Success(_sessionFor(newUser));
  }

  @override
  Future<Result<AuthSession>> signInWithGoogle({required String idToken}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (idToken.isEmpty) {
      return const Error('Google sign-in failed');
    }
    final email = 'google_${idToken.hashCode.abs() % 1000}@gmail.com';
    final user = UserModel(
      id: 'user_google_${idToken.hashCode.abs()}',
      name: 'Google User',
      email: email,
      isVerified: true,
    );
    _mockUsers[email] = user;
    _mockUsers[user.id] = user;
    return Success(_sessionFor(user));
  }

  @override
  Future<Result<AuthSession>> refreshSession({required String refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = refreshToken.replaceFirst('mock_refresh_', '');
    final user = _mockUsers[id];
    if (user == null) {
      return const Error('Session expired');
    }
    return Success(_sessionFor(user));
  }

  @override
  Future<Result<void>> logout({required String refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Success(null);
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(_mockUser);
  }

  @override
  Future<Result<void>> verifyEmail({required String code}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length == 6) {
      return const Success(null);
    }
    return const Error('Invalid verification code');
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const Success(null);
  }

  @override
  Future<Result<void>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '123456') {
      return const Success(null);
    }
    return const Error('Invalid OTP code');
  }

  @override
  Future<Result<void>> sendOtp({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (phone.isEmpty) {
      return const Error('Invalid phone number');
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!_mockUsers.containsKey(email.trim())) {
      return const Error('Email not found');
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> completeResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_mockUsers.containsKey(email.trim())) {
      return const Error('Email not found');
    }
    if (token.length != 6) {
      return const Error('Invalid reset code');
    }
    if (newPassword.length < 6) {
      return const Error('Password must be at least 6 characters');
    }
    return const Success(null);
  }
}
