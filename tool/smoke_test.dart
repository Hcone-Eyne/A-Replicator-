// End-to-end smoke test of the backend contract using the pure-Dart freezed
// models. Run while `uvicorn flow_app.main:app` is up (from backend/):
//   flutter run won't work here; use: dart run tool/smoke_test.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flow_app/features/auth/data/models/user_model.dart';
import 'package:flow_app/features/home/data/models/listing_model.dart';
import 'package:flow_app/features/messaging/data/models/conversation_model.dart';
import 'package:flow_app/features/messaging/data/models/message_model.dart';
import 'package:flow_app/features/notifications/data/models/notification_model.dart';
import 'package:flow_app/features/orders/data/models/order_model.dart';
import 'package:flow_app/features/profile/data/models/review_model.dart';
import 'package:flow_app/features/profile/data/models/seller_model.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: 'http://localhost:8000',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

int _failures = 0;

void _check(String name, bool ok, [String? detail]) {
  stdout.writeln('${ok ? 'PASS' : 'FAIL'}  $name${detail != null ? '  ($detail)' : ''}');
  if (!ok) _failures++;
}

Future<void> main() async {
  // Auth
  final me = (await _dio.get('/auth/me')).data as Map<String, dynamic>;
  final user = UserModel.fromJson(me);
  _check('auth.me', user.name == 'Carlos Mendoza' && user.wishlistIds.isNotEmpty,
      '${user.name}, wishlist=${user.wishlistIds}');

  // Listings
  final listRes = (await _dio.get('/listings', queryParameters: {'limit': 5})).data;
  final items = (listRes['items'] as List).cast<Map<String, dynamic>>();
  _check('listings.list', items.isNotEmpty, '${listRes['totalItems']} total');
  final first = ListingModel.fromJson(items.first);
  _check('listings.parse', first.price > 0,
      '${first.title} @ ${first.price} ${first.currency}');

  final detail = (await _dio.get('/listings/${first.id}')).data as Map<String, dynamic>;
  final parsed = ListingModel.fromJson(detail);
  _check('listings.detail', parsed.id == first.id, parsed.title);

  final search = (await _dio.get('/listings/search', queryParameters: {'q': 'mac'})).data;
  _check('listings.search', (search['items'] as List).isNotEmpty);

  // Profile
  final sellerRes = (await _dio.get('/sellers/user_002')).data as Map<String, dynamic>;
  final seller = SellerModel.fromJson(sellerRes);
  _check('profile.seller', seller.name == 'Maria Lopez', seller.name);

  final reviewsRes = (await _dio.get('/sellers/user_002/reviews')).data as List;
  final reviews = reviewsRes.cast<Map<String, dynamic>>().map(ReviewModel.fromJson).toList();
  _check('profile.reviews', reviews.isNotEmpty, '${reviews.length} reviews, first rating=${reviews.first.rating}');

  // Orders
  final ordersRes = (await _dio.get('/orders')).data;
  final orders = (ordersRes['items'] as List)
      .cast<Map<String, dynamic>>()
      .map(OrderModel.fromJson)
      .toList();
  _check('orders.list', orders.isNotEmpty, '${ordersRes['totalItems']} total, statuses=${orders.map((o) => o.status.value).toSet()}');
  final track = (await _dio.get('/orders/${orders.first.id}/track')).data as Map<String, dynamic>;
  _check('orders.track', track.containsKey('tracking') && track.containsKey('estimatedDelivery'));

  // Messaging
  final convosRes = (await _dio.get('/conversations')).data as List;
  final convos = convosRes.cast<Map<String, dynamic>>().map(ConversationModel.fromJson).toList();
  _check('messages.conversations', convos.isNotEmpty,
      convos.map((c) => '${c.otherUserName}(${c.otherUserInitials}/${c.otherUserAvatarColorHex})').join(', '));

  final msgsRes = (await _dio.get('/conversations/${convos.first.id}/messages')).data as List;
  final msgs = msgsRes.cast<Map<String, dynamic>>().map(MessageModel.fromJson).toList();
  _check('messages.messages', msgs.isNotEmpty, '${msgs.length} messages, lastRead=${msgs.last.isRead}');

  // Notifications
  final notifsRes = (await _dio.get('/notifications')).data;
  final notifs = (notifsRes['items'] as List)
      .cast<Map<String, dynamic>>()
      .map(NotificationModel.fromJson)
      .toList();
  _check('notifications.list', notifs.isNotEmpty,
      '${notifsRes['totalItems']} total, types=${notifs.map((n) => n.type.value).toSet()}');

  // Mutations
  final fav = await _dio.post('/listings/list_002/favorite');
  _check('mutation.favorite', fav.data['favorited'] == true);
  await _dio.post('/listings/list_002/favorite');

  stdout.writeln(_failures == 0 ? '\nALL SMOKE TESTS PASSED' : '\n$_failures FAILURES');
  exit(_failures == 0 ? 0 : 1);
}
