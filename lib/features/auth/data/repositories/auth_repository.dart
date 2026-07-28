import '../../data/models/user_model.dart';
import '../../../../shared/models/result.dart';

abstract class AuthRepository {
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<UserModel>> getCurrentUser();

  Future<Result<void>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<Result<void>> sendOtp({
    required String phone,
  });

  Future<Result<void>> resetPassword({
    required String email,
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

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _mockUsers[email];
    if (user != null && password.length >= 6) {
      return Success(user);
    }
    return const Error('Invalid email or password');
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_mockUsers.containsKey(email)) {
      return const Error('Email already registered');
    }
    if (password.length < 6) {
      return const Error('Password must be at least 6 characters');
    }

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
    );
    _mockUsers[email] = newUser;
    _mockUsers[newUser.id] = newUser;
    return Success(newUser);
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Success(null);
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(_mockUser);
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
    if (!_mockUsers.containsKey(email)) {
      return const Error('Email not found');
    }
    return const Success(null);
  }
}
