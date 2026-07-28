import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

enum OrderTab { all, processing, shipped, delivered }

class OrderState {
  final AsyncValue<List<OrderModel>> orders;
  final OrderTab selectedTab;

  const OrderState({
    this.orders = const AsyncValue.data([]),
    this.selectedTab = OrderTab.all,
  });

  OrderState copyWith({
    AsyncValue<List<OrderModel>>? orders,
    OrderTab? selectedTab,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  OrderNotifier(this._repository) : super(const OrderState());

  Future<void> getOrders({OrderStatus? status}) async {
    state = state.copyWith(orders: const AsyncValue.loading());
    final result = await _repository.getOrders(status: status);
    if (result.isSuccess) {
      state = state.copyWith(orders: AsyncValue.data(result.data!.items));
    } else {
      state = state.copyWith(
        orders: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  void filterByStatus(OrderTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  List<OrderModel> getFilteredOrders() {
    final orders = state.orders.valueOrNull ?? [];
    final tab = state.selectedTab;
    if (tab == OrderTab.all) return orders;
    return orders.where((o) {
      return switch (tab) {
        OrderTab.processing => o.status == OrderStatus.pending,
        OrderTab.shipped =>
          o.status == OrderStatus.shipped || o.status == OrderStatus.confirmed,
        OrderTab.delivered => o.status == OrderStatus.delivered,
        OrderTab.all => true,
      };
    }).toList();
  }

  OrderModel? getOrderDetails(String orderId) {
    final orders = state.orders.valueOrNull ?? [];
    try {
      return orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  Future<void> cancelOrder(String orderId, {String? reason}) async {
    final result = await _repository.cancelOrder(id: orderId, reason: reason);
    if (result.isSuccess) {
      final current = state.orders.valueOrNull ?? [];
      state = state.copyWith(
        orders: AsyncValue.data(
          current.map((o) {
            if (o.id == orderId) {
              return o.copyWith(status: OrderStatus.cancelled);
            }
            return o;
          }).toList(),
        ),
      );
    }
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return MockOrderRepository();
});

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderNotifier(repository);
});
