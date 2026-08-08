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
      return 'http://localhost:4000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000';
    }
    return 'http://localhost:4000';
  }

  /// Google OAuth2 Web client id.
  ///
  /// Used as the `clientId` on web and as the Android `serverClientId`.
  /// Fill this in from Google Cloud Console → APIs & Services → Credentials
  /// → OAuth 2.0 Client IDs → your "Web application" client.
  static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID';
}
