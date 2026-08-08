import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../data/datasources/auth_session_storage.dart';
import '../../data/datasources/google_sign_in_service.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_remote.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isInitializing;
  final bool isVerificationRequired;
  final AsyncValue<UserModel?> user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isInitializing = false,
    this.isVerificationRequired = false,
    this.user = const AsyncValue.data(null),
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isInitializing,
    bool? isVerificationRequired,
    AsyncValue<UserModel?>? user,
    bool clearUser = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitializing: isInitializing ?? this.isInitializing,
      isVerificationRequired:
          isVerificationRequired ?? this.isVerificationRequired,
      user: clearUser ? const AsyncValue.data(null) : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this._repository, {
    AuthSessionStorage? sessionStorage,
    GoogleSignInService? googleSignIn,
  })  : _sessionStorage = sessionStorage ?? AuthSessionStorage(),
        _googleSignIn = googleSignIn ?? GoogleSignInService(),
        super(const AuthState());

  final AuthRepository _repository;
  final AuthSessionStorage _sessionStorage;
  final GoogleSignInService _googleSignIn;

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }

  /// Restores a persisted session on app launch.
  ///
  /// Bounded by a timeout so a slow/offline backend or a locked keychain can
  /// never block the splash screen indefinitely.
  Future<void> initialize() async {
    if (state.isInitializing) return;
    state = state.copyWith(isInitializing: true, clearError: true);

    try {
      await _restoreSession().timeout(const Duration(seconds: 4));
    } catch (_) {
      // Timed out (no network) — continue as signed out.
    }

    state = state.copyWith(isInitializing: false);
  }

  Future<void> _restoreSession() async {
    AuthSession? session;
    try {
      session = await _sessionStorage.read();
    } catch (_) {
      session = null;
    }
    if (session == null) return;

    ApiClient.accessToken = session.accessToken;
    final userResult = await _repository.getCurrentUser();
    if (userResult.isSuccess) {
      _applySession(session, user: userResult.data);
      return;
    }

    final refreshed = await _repository.refreshSession(
      refreshToken: session.refreshToken,
    );
    if (refreshed.isSuccess) {
      _applySession(refreshed.data!);
      return;
    }

    await _sessionStorage.clear();
    ApiClient.accessToken = null;
    state = const AuthState();
  }

  void _applySession(AuthSession session, {UserModel? user}) {
    ApiClient.accessToken = session.accessToken;
    // Best-effort persistence; storage failures should not block sign-in.
    _sessionStorage.write(session);
    state = state.copyWith(
      isAuthenticated: true,
      isVerificationRequired: session.isVerificationRequired,
      user: AsyncValue.data(user ?? session.user),
      clearError: true,
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.login(email: email, password: password);
    if (result.isSuccess) {
      _applySession(result.data!);
      state = state.copyWith(isLoading: false);
    } else {
      state = state.copyWith(
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
      _applySession(result.data!);
      state = state.copyWith(isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }

  /// Signs in with Google. Returns `true` on success, `false` on failure or
  /// when the user cancels the account picker.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final idToken = await _googleSignIn.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google sign-in was cancelled or is unavailable.',
      );
      return false;
    }
    final result = await _repository.signInWithGoogle(idToken: idToken);
    if (result.isSuccess) {
      _applySession(result.data!);
      state = state.copyWith(isLoading: false);
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: result.errorMessage,
    );
    return false;
  }

  Future<void> logout() async {
    try {
      final session = await _sessionStorage.read();
      if (session != null) {
        await _repository.logout(refreshToken: session.refreshToken);
      }
    } catch (_) {
      // Best-effort remote revoke; local state is cleared regardless.
    }
    await _sessionStorage.clear();
    ApiClient.accessToken = null;
    state = const AuthState();
  }

  Future<bool> sendEmailVerification() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.sendEmailVerification();
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    }
    state = state.copyWith(error: result.errorMessage);
    return false;
  }

  Future<bool> verifyEmail(String code) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.verifyEmail(code: code);
    if (result.isSuccess) {
      final current = state.user.valueOrNull;
      state = state.copyWith(
        isAuthenticated: true,
        isVerificationRequired: false,
        user: AsyncValue.data(
          current == null ? null : current.copyWith(isVerified: true),
        ),
        isLoading: false,
      );
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: result.errorMessage,
    );
    return false;
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.resetPassword(email: email);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    }
    state = state.copyWith(error: result.errorMessage);
    return false;
  }

  Future<bool> completeResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.completeResetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    }
    state = state.copyWith(error: result.errorMessage);
    return false;
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.sendOtp(phone: phone);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    }
    state = state.copyWith(error: result.errorMessage);
    return false;
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.verifyOtp(phone: phone, otp: otp);
    state = state.copyWith(isLoading: false);
    if (result.isSuccess) {
      return true;
    }
    state = state.copyWith(error: result.errorMessage);
    return false;
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
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (ApiConfig.useRemoteBackend) {
    return AuthRemoteRepository();
  }
  return MockAuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user.valueOrNull;
});
