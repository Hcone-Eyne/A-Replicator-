import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/result.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../repositories/messaging_repository.dart';

class MessagingRemoteRepository extends ApiRepository
    implements MessagingRepository {
  @override
  Future<Result<List<ConversationModel>>> getConversations() {
    return guard(() async {
      final response = await ApiClient.dio.get('/conversations');
      return (response.data as List<dynamic>)
          .map(
            (item) =>
                ConversationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<Result<List<MessageModel>>> getMessages({
    required String conversationId,
    int limit = 50,
    String? before,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/conversations/$conversationId/messages',
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before,
        },
      );
      return (response.data as List<dynamic>)
          .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<MessageModel>> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.post(
        '/conversations/$conversationId/messages',
        data: {'text': text, 'imageUrl': imageUrl ?? ''},
      );
      return MessageModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<void>> markAsRead({required String conversationId}) {
    return guardVoid(() => ApiClient.dio.post('/conversations/$conversationId/read'));
  }

  @override
  Future<Result<int>> getUnreadCount() {
    return guard(() async {
      final response = await ApiClient.dio.get('/conversations/unread-count');
      return (response.data as Map<String, dynamic>)['count'] as int;
    });
  }
}
