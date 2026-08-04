import '../models/order_model.dart';
import '../../../home/data/repositories/listing_repository.dart';
import '../../../../shared/models/pagination.dart';
import '../../../../shared/models/result.dart';

abstract class OrderRepository {
  Future<Result<Pagination<OrderModel>>> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  });

  Future<Result<OrderModel>> getOrderById({
    required String id,
  });

  Future<Result<OrderModel>> createOrder({
    required String listingId,
    int quantity = 1,
    String shippingAddress = '',
    String paymentMethod = '',
  });

  Future<Result<void>> cancelOrder({
    required String id,
    String? reason,
  });

  Future<Result<Map<String, dynamic>>> trackOrder({
    required String id,
  });
}

class MockOrderRepository implements OrderRepository {
  static final _mockOrders = <String, OrderModel>{
    'ord_001': OrderModel(
      id: 'ord_001',
      buyerId: 'user_001',
      sellerId: 'user_002',
      listingId: 'list_001',
      listingTitle: 'iPhone 15 Pro Max 256GB',
      listingImage: '',
      price: 18500.0,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      shippingAddress: 'Av. Reforma 123, Ciudad de Mexico',
    ),
    'ord_002': OrderModel(
      id: 'ord_002',
      buyerId: 'user_001',
      sellerId: 'user_004',
      listingId: 'list_003',
      listingTitle: 'MacBook Air M2 13"',
      listingImage: '',
      price: 21000.0,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      shippingAddress: 'Calle Independencia 456, Monterrey',
    ),
    'ord_003': OrderModel(
      id: 'ord_003',
      buyerId: 'user_001',
      sellerId: 'user_003',
      listingId: 'list_002',
      listingTitle: 'Nike Air Max 90 Talla 10',
      listingImage: '',
      price: 1800.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      shippingAddress: 'Blvd. Vallarta 789, Guadalajara',
    ),
    'ord_004': OrderModel(
      id: 'ord_004',
      buyerId: 'user_001',
      sellerId: 'user_005',
      listingId: 'list_004',
      listingTitle: 'Sofa 3 Plazas Color Gris',
      listingImage: '',
      price: 5500.0,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      shippingAddress: 'Calle 5 de Mayo 101, Puebla',
    ),
    'ord_005': OrderModel(
      id: 'ord_005',
      buyerId: 'user_001',
      sellerId: 'user_006',
      listingId: 'list_005',
      listingTitle: 'Bicicleta de Montaña Trek',
      listingImage: '',
      price: 4200.0,
      status: OrderStatus.cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      shippingAddress: 'Av. Universidad 202, Queretaro',
    ),
  };

  List<OrderModel> _getFiltered({OrderStatus? status}) {
    return _mockOrders.values.where((o) {
      return status == null || o.status == status;
    }).toList();
  }

  @override
  Future<Result<Pagination<OrderModel>>> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final items = _getFiltered(status: status);
    final totalItems = items.length;
    final totalPages = (totalItems / limit).ceil().clamp(1, 999);
    final start = (page - 1) * limit;
    final end = start + limit;
    final pagedItems = items.sublist(start, end.clamp(0, totalItems));

    return Success(Pagination<OrderModel>(
      items: pagedItems,
      page: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasMore: page < totalPages,
    ));
  }

  @override
  Future<Result<OrderModel>> getOrderById({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final order = _mockOrders[id];
    if (order == null) return const Error('Order not found');
    return Success(order);
  }

  @override
  Future<Result<OrderModel>> createOrder({
    required String listingId,
    int quantity = 1,
    String shippingAddress = '',
    String paymentMethod = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final listing = MockListingRepository.getById(listingId);
    final order = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      buyerId: 'user_001',
      sellerId: listing?.sellerId ?? 'user_002',
      listingId: listingId,
      listingTitle: listing?.title ?? 'Listing',
      listingImage: listing?.images.isNotEmpty == true ? listing!.images.first : '',
      price: listing?.price ?? 0.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      isPaid: paymentMethod.isNotEmpty,
      quantity: quantity,
    );
    _mockOrders[order.id] = order;
    return Success(order);
  }

  @override
  Future<Result<void>> cancelOrder({required String id, String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final order = _mockOrders[id];
    if (order == null) return const Error('Order not found');
    if (order.status == OrderStatus.delivered) {
      return const Error('Cannot cancel a delivered order');
    }
    _mockOrders[id] = order.copyWith(status: OrderStatus.cancelled);
    return const Success(null);
  }

  @override
  Future<Result<Map<String, dynamic>>> trackOrder({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final order = _mockOrders[id];
    if (order == null) return const Error('Order not found');

    return Success({
      'orderId': order.id,
      'status': order.status.value,
      'tracking': [
        {'status': 'Order placed', 'date': order.createdAt.toIso8601String()},
        {'status': 'Payment confirmed', 'date': order.createdAt.add(const Duration(hours: 1)).toIso8601String()},
        {'status': 'Shipped', 'date': order.createdAt.add(const Duration(days: 1)).toIso8601String()},
      ],
      'estimatedDelivery': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    });
  }
}
