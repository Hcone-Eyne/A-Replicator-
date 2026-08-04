import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/pagination.dart';
import '../../../../shared/models/result.dart';
import '../../data/models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderRemoteRepository extends ApiRepository implements OrderRepository {
  @override
  Future<Result<Pagination<OrderModel>>> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/orders',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status.value,
        },
      );
      return parsePagination(
        response.data as Map<String, dynamic>,
        OrderModel.fromJson,
      );
    });
  }

  @override
  Future<Result<OrderModel>> getOrderById({required String id}) {
    return guard(() async {
      final response = await ApiClient.dio.get('/orders/$id');
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<OrderModel>> createOrder({
    required String listingId,
    int quantity = 1,
    String shippingAddress = '',
    String paymentMethod = '',
  }) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/orders',
        data: {
          'listingId': listingId,
          'quantity': quantity,
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
        },
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<void>> cancelOrder({
    required String id,
    String? reason,
  }) {
    return guardVoid(
      () => ApiClient.dio.post(
        '/orders/$id/cancel',
        data: {'reason': reason},
      ),
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> trackOrder({required String id}) {
    return guard(() async {
      final response = await ApiClient.dio.get('/orders/$id/track');
      return (response.data as Map<String, dynamic>).cast<String, dynamic>();
    });
  }
}
