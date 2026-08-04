import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/navigation/navigation_utils.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/navigation/app_page_header.dart';
import '../../../../shared/widgets/async_value_ui.dart';
import '../../../notifications/data/models/notification_model.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _selectedFilter = 0;

  static const _filters = ['All', 'Orders', 'Messages', 'System', 'Promotions'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).getNotifications();
    });
  }

  List<NotificationModel> get _filteredNotifications {
    final notifications =
        ref.watch(notificationProvider).notifications.valueOrNull ?? [];
    if (_selectedFilter == 0) return notifications;
    return notifications.where((n) {
      return switch (_selectedFilter) {
        1 => n.type == NotificationType.order,
        2 => n.type == NotificationType.message,
        3 => n.type == NotificationType.system,
        4 => n.type == NotificationType.promotion,
        _ => true,
      };
    }).toList();
  }

  void _onNotificationTap(NotificationModel notification) {
    ref.read(notificationProvider.notifier).markAsRead(notification.id);
    final data = notification.data;
    if (data['conversationId'] != null) {
      context.pushNamed(
        RouteNames.nConversation,
        pathParameters: {'id': data['conversationId'] as String},
      );
    } else if (data['orderId'] != null) {
      context.pushNamed(
        RouteNames.nTrackOrder,
        pathParameters: {'id': data['orderId'] as String},
      );
    } else if (data['listingId'] != null) {
      context.pushNamed(
        RouteNames.nProductDetails,
        pathParameters: {'id': data['listingId'] as String},
      );
    }
  }

  Future<void> _markAllAsRead() async {
    await ref.read(notificationProvider.notifier).markAllAsRead();
    if (!mounted) return;
    AppSnackbar.show(context, 'All notifications marked as read');
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

  String _sectionTitle(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(time.year, time.month, time.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return 'Earlier';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final notifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'Notifications',
              onBack: () => NavigationUtils.safeBack(context),
              divider: true,
              actions: [
                TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'MARK ALL READ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _buildFilterChips(),
            ),
            Expanded(
              child: AsyncValueListUI<NotificationModel>(
                value: state.notifications,
                onRetry: () =>
                    ref.read(notificationProvider.notifier).getNotifications(),
                emptyTitle: 'No notifications',
                emptySubtitle: 'You\'re all caught up.',
                emptyIcon: const Icon(Icons.notifications_none),
                data: (_) => notifications.isEmpty
                    ? AsyncValueListUI<NotificationModel>(
                        value: state.notifications,
                        emptyTitle: 'No ${_filters[_selectedFilter].toLowerCase()} notifications',
                        emptySubtitle: 'Nothing here right now.',
                        emptyIcon: const Icon(Icons.notifications_none),
                        data: (_) => const SizedBox.shrink(),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        children: _buildSections(notifications),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: isSelected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSecondaryContainer,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSections(List<NotificationModel> notifications) {
    final sections = <String, List<NotificationModel>>{};
    for (final notification in notifications) {
      final title = _sectionTitle(notification.createdAt);
      sections.putIfAbsent(title, () => []).add(notification);
    }
    final order = ['Today', 'Yesterday', 'Earlier'];
    final widgets = <Widget>[];
    for (final title in order) {
      final items = sections[title];
      if (items == null || items.isEmpty) continue;
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 12),
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: AppColors.secondary,
          ),
        ),
      ));
      widgets.addAll(items.map(_buildNotificationCard));
    }
    return widgets;
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final iconData = _iconForType(notification.type);
    return GestureDetector(
      onTap: () => _onNotificationTap(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.surfaceContainer),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(iconData),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.primary, size: 24),
    );
  }

  IconData _iconForType(NotificationType type) {
    return switch (type) {
      NotificationType.order => Icons.local_shipping_outlined,
      NotificationType.message => Icons.chat_outlined,
      NotificationType.system => Icons.info_outline,
      NotificationType.promotion => Icons.sell_outlined,
    };
  }
}
