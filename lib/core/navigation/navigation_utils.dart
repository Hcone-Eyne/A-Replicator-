import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationUtils {
  NavigationUtils._();

  static void safeBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
