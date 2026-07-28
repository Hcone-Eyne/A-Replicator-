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
    final isAuthRoute = [
      RouteNames.login,
      RouteNames.signUp,
      RouteNames.otpVerification,
      RouteNames.forgotPassword,
      RouteNames.securityVerification,
    ].contains(state.matchedLocation);

    if (!isAuthenticated && !isAuthRoute && state.matchedLocation != RouteNames.splash) {
      return RouteNames.login;
    }
    if (isAuthenticated && isAuthRoute) {
      return RouteNames.home;
    }
    return null;
  }
}