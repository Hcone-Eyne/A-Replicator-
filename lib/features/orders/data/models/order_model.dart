import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
  refunded;

  factory OrderStatus.fromString(String value) {
    return switch (value) {
      'pending' => OrderStatus.pending,
      'confirmed' => OrderStatus.confirmed,
      'shipped' => OrderStatus.shipped,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      'refunded' => OrderStatus.refunded,
      _ => OrderStatus.pending,
    };
  }

  String get value => switch (this) {
        OrderStatus.pending => 'pending',
        OrderStatus.confirmed => 'confirmed',
        OrderStatus.shipped => 'shipped',
        OrderStatus.delivered => 'delivered',
        OrderStatus.cancelled => 'cancelled',
        OrderStatus.refunded => 'refunded',
      };
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String buyerId,
    required String sellerId,
    required String listingId,
    @Default('') String listingTitle,
    @Default('') String listingImage,
    @Default(0.0) double price,
    @Default('NGN') String currency,
    @Default(OrderStatus.pending) OrderStatus status,
    required DateTime createdAt,
    @Default('') String shippingAddress,
    @Default('') String paymentMethod,
    @Default(false) bool isPaid,
    @Default(0) int quantity,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
