import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/feedback/app_loading.dart';
import '../../core/widgets/feedback/app_error.dart';
import '../../core/widgets/feedback/app_empty_state.dart';

class AsyncValueUI<T> extends StatelessWidget {
  const AsyncValueUI({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.isEmpty,
    this.emptyTitle = 'No data available',
    this.emptySubtitle,
    this.emptyIcon,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stack)? error;
  final bool Function(T data)? isEmpty;
  final String emptyTitle;
  final String? emptySubtitle;
  final Widget? emptyIcon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading?.call() ?? const Center(child: AppLoading()),
      error: (e, stack) =>
          error?.call(e, stack) ??
          AppError(
            message: e.toString(),
            onRetry: onRetry,
          ),
      data: (data) {
        if (isEmpty?.call(data) == true) {
          return AppEmptyState(
            title: emptyTitle,
            subtitle: emptySubtitle,
            icon: emptyIcon,
          );
        }
        return this.data(data);
      },
    );
  }
}

class AsyncValueListUI<T> extends StatelessWidget {
  const AsyncValueListUI({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.emptyTitle = 'No items available',
    this.emptySubtitle,
    this.emptyIcon,
    this.onRetry,
  });

  final AsyncValue<List<T>> value;
  final Widget Function(List<T> items) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stack)? error;
  final String emptyTitle;
  final String? emptySubtitle;
  final Widget? emptyIcon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AsyncValueUI<List<T>>(
      value: value,
      data: data,
      loading: loading,
      error: error,
      isEmpty: (items) => items.isEmpty,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      emptyIcon: emptyIcon,
      onRetry: onRetry,
    );
  }
}
