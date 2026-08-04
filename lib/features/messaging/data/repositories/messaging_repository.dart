import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../../../../shared/models/result.dart';

abstract class MessagingRepository {
  Future<Result<List<ConversationModel>>> getConversations();

  Future<Result<ConversationModel>> createConversation({
    required String otherUserId,
    String? productId,
    String productTitle = '',
    String productImage = '',
    String initialMessage = '',
  });

  Future<Result<List<MessageModel>>> getMessages({
    required String conversationId,
    int limit = 50,
    String? before,
  });

  Future<Result<MessageModel>> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  });

  Future<Result<void>> markAsRead({
    required String conversationId,
  });

  Future<Result<int>> getUnreadCount();
}

class MockMessagingRepository implements MessagingRepository {
  static final _mockConversations = <String, ConversationModel>{
    'conv_001': ConversationModel(
      id: 'conv_001',
      otherUserId: 'user_002',
      otherUserName: 'Maria Lopez',
      otherUserInitials: 'ML',
      otherUserAvatarColorHex: '#2196F3',
      lastMessage: 'Si, esta disponible. Te lo puedo enviar manana.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 2,
      isOnline: true,
      isVerified: true,
      productTitle: 'iPhone 15 Pro Max 256GB',
    ),
    'conv_002': ConversationModel(
      id: 'conv_002',
      otherUserId: 'user_003',
      otherUserName: 'Juan Perez',
      otherUserInitials: 'JP',
      otherUserAvatarColorHex: '#4CAF50',
      lastMessage: 'Gracias por la compra!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
      productTitle: 'Nike Air Max 90 Talla 10',
    ),
    'conv_003': ConversationModel(
      id: 'conv_003',
      otherUserId: 'user_004',
      otherUserName: 'Ana Garcia',
      otherUserInitials: 'AG',
      otherUserAvatarColorHex: '#FF9800',
      lastMessage: 'Tiene algun descuento?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: true,
      productTitle: 'MacBook Air M2 13"',
    ),
  };

  static final _mockMessages = <String, List<MessageModel>>{
    'conv_001': [
      MessageModel(
        id: 'msg_001',
        conversationId: 'conv_001',
        senderId: 'user_001',
        text: 'Hola, esta disponible el iPhone?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MessageModel(
        id: 'msg_002',
        conversationId: 'conv_001',
        senderId: 'user_002',
        text: 'Si, esta disponible.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      MessageModel(
        id: 'msg_003',
        conversationId: 'conv_001',
        senderId: 'user_001',
        text: 'Cual es el precio final?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageModel(
        id: 'msg_004',
        conversationId: 'conv_001',
        senderId: 'user_002',
        text: 'Si, esta disponible. Te lo puedo enviar manana.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
    'conv_002': [
      MessageModel(
        id: 'msg_005',
        conversationId: 'conv_002',
        senderId: 'user_001',
        text: 'Recibi los zapatos, gracias!',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      MessageModel(
        id: 'msg_006',
        conversationId: 'conv_002',
        senderId: 'user_003',
        text: 'Gracias por la compra!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
    'conv_003': [
      MessageModel(
        id: 'msg_007',
        conversationId: 'conv_003',
        senderId: 'user_001',
        text: 'Buenas tardes, me interesa el MacBook.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      ),
      MessageModel(
        id: 'msg_008',
        conversationId: 'conv_003',
        senderId: 'user_004',
        text: 'Hola! Si esta disponible.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MessageModel(
        id: 'msg_009',
        conversationId: 'conv_003',
        senderId: 'user_001',
        text: 'Tiene algun descuento?',
        timestamp: DateTime.now().subtract(const Duration(hours: 23)),
      ),
    ],
  };

  static const _mockUserNames = {
    'user_002': 'Maria Lopez',
    'user_003': 'Juan Perez',
    'user_004': 'Ana Garcia',
    'user_005': 'Sofia Torres',
    'user_006': 'Diego Rivera',
  };

  @override
  Future<Result<List<ConversationModel>>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final sorted = _mockConversations.values.toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return Success(sorted);
  }

  @override
  Future<Result<ConversationModel>> createConversation({
    required String otherUserId,
    String? productId,
    String productTitle = '',
    String productImage = '',
    String initialMessage = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final conversation = ConversationModel(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      otherUserId: otherUserId,
      otherUserName: _mockUserNames[otherUserId] ?? 'Seller',
      otherUserInitials: (_mockUserNames[otherUserId] ?? 'Seller')
          .split(' ')
          .map((p) => p[0])
          .take(2)
          .join()
          .toUpperCase(),
      lastMessage: initialMessage,
      lastMessageTime: DateTime.now(),
      productTitle: productTitle,
      productImage: productImage,
    );

    _mockConversations[conversation.id] = conversation;
    _mockMessages[conversation.id] = initialMessage.isNotEmpty
        ? [
            MessageModel(
              id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
              conversationId: conversation.id,
              senderId: 'user_001',
              text: initialMessage,
              timestamp: DateTime.now(),
            ),
          ]
        : [];
    return Success(conversation);
  }

  @override
  Future<Result<List<MessageModel>>> getMessages({
    required String conversationId,
    int limit = 50,
    String? before,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final messages = _mockMessages[conversationId] ?? [];
    var filtered = messages;
    if (before != null) {
      filtered = messages.where((m) => m.timestamp.isBefore(DateTime.parse(before))).toList();
    }
    if (filtered.length > limit) {
      filtered = filtered.sublist(filtered.length - limit);
    }
    return Success(filtered);
  }

  @override
  Future<Result<MessageModel>> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newMessage = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user_001',
      text: text,
      timestamp: DateTime.now(),
    );

    _mockMessages.putIfAbsent(conversationId, () => []);
    _mockMessages[conversationId]!.add(newMessage);

    if (_mockConversations.containsKey(conversationId)) {
      _mockConversations[conversationId] = _mockConversations[conversationId]!.copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
      );
    }

    return Success(newMessage);
  }

  @override
  Future<Result<void>> markAsRead({required String conversationId}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final messages = _mockMessages[conversationId];
    if (messages != null) {
      _mockMessages[conversationId] = messages.map((m) => m.copyWith(isRead: true)).toList();
    }
    if (_mockConversations.containsKey(conversationId)) {
      _mockConversations[conversationId] = _mockConversations[conversationId]!.copyWith(
        unreadCount: 0,
      );
    }
    return const Success(null);
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final total = _mockConversations.values.fold(0, (sum, c) => sum + c.unreadCount);
    return Success(total);
  }
}
