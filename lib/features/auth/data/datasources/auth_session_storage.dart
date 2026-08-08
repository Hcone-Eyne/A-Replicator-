import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_session.dart';

/// Persists the [AuthSession] in the platform secure store.
class AuthSessionStorage {
  AuthSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  Future<AuthSession?> read() async {
    try {
      final raw = await _storage.read(key: _sessionKey);
      if (raw == null || raw.isEmpty) return null;
      return AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(AuthSession session) async {
    try {
      await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    } catch (_) {
      // Best-effort persistence; a failed write just means no session restore
      // on the next launch.
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _sessionKey);
    } catch (_) {
      // Best-effort cleanup; a stale session simply fails the next restore.
    }
  }
}
