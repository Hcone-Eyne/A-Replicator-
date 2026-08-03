import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/messaging_repository.dart';
import '../../data/repositories/messaging_repository_remote.dart';

enum ConversationFilter { all, unread, sellers }

class MessagingState {
  final AsyncValue<List<ConversationModel>> conversations;
  final ConversationFilter selectedFilter;
  final String searchQuery;

  const MessagingState({
    this.conversations = const AsyncValue.data([]),
    this.selectedFilter = ConversationFilter.all,
    this.searchQuery = '',
  });

  MessagingState copyWith({
    AsyncValue<List<ConversationModel>>? conversations,
    ConversationFilter? selectedFilter,
    String? searchQuery,
  }) {
    return MessagingState(
      conversations: conversations ?? this.conversations,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MessagingNotifier extends StateNotifier<MessagingState> {
  final MessagingRepository _repository;

  MessagingNotifier(this._repository) : super(const MessagingState());

  Future<void> getConversations() async {
    state = state.copyWith(conversations: const AsyncValue.loading());
    final result = await _repository.getConversations();
    if (result.isSuccess) {
      state = state.copyWith(conversations: AsyncValue.data(result.data!));
    } else {
      state = state.copyWith(
        conversations: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  void search(String query) {
    final allConversations = state.conversations.valueOrNull ?? [];
    final filtered = allConversations.where((conv) {
      final matchesQuery = query.isEmpty ||
          conv.otherUserName
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          conv.productTitle.toLowerCase().contains(query.toLowerCase());
      final matchesFilter = _matchesFilter(conv);
      return matchesQuery && matchesFilter;
    }).toList();
    state = state.copyWith(
      searchQuery: query,
      conversations: AsyncValue.data(filtered),
    );
  }

  void filter(ConversationFilter filter) {
    final allConversations = state.conversations.valueOrNull ?? [];
    final filtered = allConversations.where((conv) {
      final matchesFilter = _matchesFilter(conv, filter);
      final matchesQuery = state.searchQuery.isEmpty ||
          conv.otherUserName
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase());
      return matchesQuery && matchesFilter;
    }).toList();
    state = state.copyWith(
      selectedFilter: filter,
      conversations: AsyncValue.data(filtered),
    );
  }

  bool _matchesFilter(ConversationModel conv, [ConversationFilter? filter]) {
    final f = filter ?? state.selectedFilter;
    return switch (f) {
      ConversationFilter.all => true,
      ConversationFilter.unread => conv.unreadCount > 0,
      ConversationFilter.sellers => conv.isVerified,
    };
  }

  Future<void> markAsRead(String conversationId) async {
    await _repository.markAsRead(conversationId: conversationId);
    final current = state.conversations.valueOrNull ?? [];
    state = state.copyWith(
      conversations: AsyncValue.data(
        current.map((c) {
          if (c.id == conversationId) {
            return c.copyWith(unreadCount: 0);
          }
          return c;
        }).toList(),
      ),
    );
    filter(state.selectedFilter);
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  if (ApiConfig.useRemoteBackend) {
    return MessagingRemoteRepository();
  }
  return MockMessagingRepository();
});

final messagingProvider =
    StateNotifierProvider<MessagingNotifier, MessagingState>((ref) {
  final repository = ref.watch(messagingRepositoryProvider);
  return MessagingNotifier(repository);
});

class ConversationState {
  final AsyncValue<ConversationModel?> conversation;
  final AsyncValue<List<MessageModel>> messages;

  const ConversationState({
    this.conversation = const AsyncValue.data(null),
    this.messages = const AsyncValue.data([]),
  });

  ConversationState copyWith({
    AsyncValue<ConversationModel?>? conversation,
    AsyncValue<List<MessageModel>>? messages,
  }) {
    return ConversationState(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
    );
  }
}

class ConversationNotifier extends StateNotifier<ConversationState> {
  final MessagingRepository _repository;

  ConversationNotifier(this._repository) : super(const ConversationState());

  Future<void> loadConversation(String conversationId) async {
    state = state.copyWith(
      conversation: const AsyncValue.loading(),
      messages: const AsyncValue.loading(),
    );
    final result = await _repository.getMessages(conversationId: conversationId);
    if (result.isSuccess) {
      final conversations = await _repository.getConversations();
      ConversationModel? conv;
      if (conversations.isSuccess) {
        try {
          conv = conversations.data!.firstWhere((c) => c.id == conversationId);
        } catch (_) {}
      }
      state = state.copyWith(
        conversation: AsyncValue.data(conv),
        messages: AsyncValue.data(result.data!),
      );
    } else {
      state = state.copyWith(
        messages: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty || state.conversation.valueOrNull == null) return;
    final convId = state.conversation.valueOrNull!.id;
    final result = await _repository.sendMessage(
      conversationId: convId,
      text: text,
    );
    if (result.isSuccess) {
      final currentMessages = state.messages.valueOrNull ?? [];
      state = state.copyWith(
        messages: AsyncValue.data([...currentMessages, result.data!]),
      );
    }
  }
}

final conversationProvider =
    StateNotifierProvider<ConversationNotifier, ConversationState>((ref) {
  final repository = ref.watch(messagingRepositoryProvider);
  return ConversationNotifier(repository);
});
