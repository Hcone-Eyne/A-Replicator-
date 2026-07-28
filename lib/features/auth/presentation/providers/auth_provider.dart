import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  final bool isAuthenticated;
  final AsyncValue<UserModel?> user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user = const AsyncValue.data(null),
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    AsyncValue<UserModel?>? user,
    bool clearUser = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? const AsyncValue.data(null) : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.login(email: email, password: password);
    if (result.isSuccess) {
      state = state.copyWith(
        isAuthenticated: true,
        user: AsyncValue.data(result.data),
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        user: AsyncValue.error(result.errorMessage!, StackTrace.empty),
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.register(
      name: name,
      email: email,
      phone: '',
      password: password,
    );
    if (result.isSuccess) {
      state = state.copyWith(
        isAuthenticated: true,
        user: AsyncValue.data(result.data),
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        user: AsyncValue.error(result.errorMessage!, StackTrace.empty),
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.resetPassword(email: email);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    } else {
      state = state.copyWith(error: result.errorMessage);
      return false;
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.sendOtp(phone: phone);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    } else {
      state = state.copyWith(error: result.errorMessage);
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.verifyOtp(phone: phone, otp: otp);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    } else {
      state = state.copyWith(error: result.errorMessage);
      return false;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? location,
    String? avatarUrl,
  }) async {
    final currentUser = state.user.valueOrNull;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getCurrentUser();
    if (result.isSuccess) {
      var updated = result.data!;
      if (name != null) updated = updated.copyWith(name: name);
      if (phone != null) updated = updated.copyWith(phone: phone);
      if (location != null) updated = updated.copyWith(location: location);
      if (avatarUrl != null) updated = updated.copyWith(avatarUrl: avatarUrl);
      state = state.copyWith(user: AsyncValue.data(updated), isLoading: false);
    } else {
      state = state.copyWith(
        user: AsyncValue.error(result.errorMessage!, StackTrace.empty),
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user.valueOrNull;
});
