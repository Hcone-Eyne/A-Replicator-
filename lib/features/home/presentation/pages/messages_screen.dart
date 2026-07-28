import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/navigation/app_page_header.dart';
import '../../../../core/widgets/navigation/app_tab_bar.dart';
import '../../../../core/widgets/inputs/app_search_field.dart';
import '../../../../core/widgets/media/app_avatar.dart';
import '../../../messaging/presentation/providers/messaging_provider.dart';
import '../../../messaging/data/models/conversation_model.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _searchController = TextEditingController();

  static const _filterLabels = ['All', 'Buying', 'Selling', 'Unread', 'Archived'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ConversationModel> get _filteredConversations {
    final state = ref.watch(messagingProvider);
    return state.conversations.valueOrNull ?? [];
  }

  int get _totalUnread {
    final state = ref.read(messagingProvider);
    final conversations = state.conversations.valueOrNull ?? [];
    return conversations.fold(0, (sum, c) => sum + c.unreadCount);
  }

  void _onFilterSelected(int index) {
    final filter = switch (index) {
      0 => ConversationFilter.all,
      1 => ConversationFilter.all,
      2 => ConversationFilter.sellers,
      3 => ConversationFilter.unread,
      4 => ConversationFilter.all,
      _ => ConversationFilter.all,
    };
    ref.read(messagingProvider.notifier).filter(filter);
  }

  void _onSearchChanged(String query) {
    ref.read(messagingProvider.notifier).search(query);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.month}/${time.day}';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagingProvider.notifier).getConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagingState = ref.watch(messagingProvider);
    final conversations = _filteredConversations;

    return SafeArea(
      child: Column(
        children: [
          AppPageHeader(
            title: 'Messages',
            actions: [
              if (_totalUnread > 0)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () => context.pushNamed(RouteNames.nNotifications),
                      icon: const Icon(Icons.notifications_outlined,
                          color: AppColors.onSurface, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _totalUnread > 9 ? '9+' : '$_totalUnread',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onError,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                IconButton(
                  onPressed: () => context.pushNamed(RouteNames.nNotifications),
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.onSurface, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppSearchField(
              controller: _searchController,
              hint: 'Search conversations...',
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 12),
          AppTabBar(
            tabs: _filterLabels,
            selectedIndex: _getSelectedFilterIndex(),
            onSelected: _onFilterSelected,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: messagingState.conversations.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (_) => conversations.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      itemCount: conversations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildConversationCard(conversations[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedFilterIndex() {
    final filter = ref.read(messagingProvider).selectedFilter;
    return switch (filter) {
      ConversationFilter.all => 0,
      ConversationFilter.unread => 3,
      ConversationFilter.sellers => 2,
    };
  }

  Widget _buildEmptyState() {
    final hasSearch = _searchController.text.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 36,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasSearch ? 'No conversations found' : 'No conversations',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try a different search term.'
                  : 'Start a conversation by contacting a seller.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationCard(ConversationModel conversation) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.nConversation,
        pathParameters: {'id': conversation.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AppAvatar(
              name: conversation.otherUserName,
              size: AppAvatarSize.lg,
              isOnline: conversation.isOnline,
              isVerified: conversation.isVerified,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          conversation.otherUserName,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: AppColors.onTertiaryContainer,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation.productTitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.05,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: conversation.unreadCount > 0
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(conversation.lastMessageTime),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: conversation.unreadCount > 0
                        ? AppColors.primary
                        : AppColors.outline,
                  ),
                ),
                const SizedBox(height: 6),
                if (conversation.unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
