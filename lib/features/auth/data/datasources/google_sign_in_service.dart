import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/network/api_config.dart';/// Wraps the Google Sign-In plugin so the auth layer depends on a small
/// interface instead of the plugin directly.
class GoogleSignInService {
  GoogleSignInService({GoogleSignIn? signIn})
      : _signIn = signIn ?? _buildDefaultSignIn();

  final GoogleSignIn _signIn;

  static GoogleSignIn _buildDefaultSignIn() {
    if (kIsWeb) {
      return GoogleSignIn(clientId: ApiConfig.googleWebClientId);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android needs the serverClientId (the Web OAuth client id) to return
      // an ID token whose audience the backend can verify.
      return GoogleSignIn(serverClientId: ApiConfig.googleWebClientId);
    }
    return GoogleSignIn();
  }

  /// Prompts the Google account picker and returns the OAuth2 ID token,
  /// or `null` when the user cancels or the platform cannot sign in.
  Future<String?> getIdToken() async {
    try {
      final account = await _signIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.idToken;
    } catch (_) {
      return null;
    }
  }

  /// Signs the user out of Google on the device.
  Future<void> signOut() => _signIn.signOut();
}
