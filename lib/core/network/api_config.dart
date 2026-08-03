import 'package:flutter/foundation.dart';

/// Central switch between the mock repositories and the live FastAPI backend.
class ApiConfig {
  const ApiConfig._();

  /// When `true`, providers use the HTTP repositories against MySQL.
  /// When `false`, the app runs fully on mock data (used by tests).
  static const bool useRemoteBackend = true;

  /// Base URL of the FastAPI backend, resolved per platform.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }
}
