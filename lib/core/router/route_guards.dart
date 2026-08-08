import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'route_names.dart';

class RouteGuards {
  RouteGuards._();

  static String? handleAuthRedirect(BuildContext context, GoRouterState state) {
    final authState = ProviderScope.containerOf(context, listen: false).read(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    final location = state.matchedLocation;

    if (authState.isInitializing && location != RouteNames.splash) {
      return RouteNames.splash;
    }

    final isAuthRoute = [
      RouteNames.login,
      RouteNames.signUp,
      RouteNames.forgotPassword,
      RouteNames.securityVerification,
    ].contains(location);

    // OTP verification is reachable both before and after login (email
    // verification step), so it is not treated as an auth-route redirect.
    final isOtpRoute = location == RouteNames.otpVerification;

    if (!isAuthenticated && !isAuthRoute && !isOtpRoute && location != RouteNames.splash) {
      return RouteNames.login;
    }
    if (isAuthenticated && isAuthRoute) {
      return RouteNames.home;
    }
    return null;
  }
}