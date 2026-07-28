import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/navigation/app_page_header.dart';
import '../../../../core/widgets/navigation/app_tab_bar.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../../orders/data/models/order_model.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  static const _tabs = ['All', 'Processing', 'Shipped', 'Delivered'];

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.pending => AppColors.primaryContainer,
        OrderStatus.confirmed => AppColors.primaryContainer,
        OrderStatus.shipped => AppColors.primary,
        OrderStatus.delivered => AppColors.onTertiaryContainer,
        OrderStatus.cancelled => AppColors.error,
        OrderStatus.refunded => AppColors.error,
      };

  String _statusLabel(OrderStatus status) => switch (status) {
        OrderStatus.pending => 'PENDING',
        OrderStatus.confirmed => 'CONFIRMED',
        OrderStatus.shipped => 'SHIPPED',
        OrderStatus.delivered => 'DELIVERED',
        OrderStatus.cancelled => 'CANCELLED',
        OrderStatus.refunded => 'REFUNDED',
      };

  IconData _orderIcon(OrderStatus status) => switch (status) {
        OrderStatus.pending => Icons.inventory_2_outlined,
        OrderStatus.confirmed => Icons.inventory_2_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.check_circle_outline,
        OrderStatus.cancelled => Icons.cancel_outlined,
        OrderStatus.refunded => Icons.replay_outlined,
      };

  void _onTabSelected(int index) {
    final tab = switch (index) {
      0 => OrderTab.all,
      1 => OrderTab.processing,
      2 => OrderTab.shipped,
      3 => OrderTab.delivered,
      _ => OrderTab.all,
    };
    ref.read(orderProvider.notifier).filterByStatus(tab);
  }

  void _showOrderMenu(OrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                order.listingTitle,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.outlineVariant, height: 1),
            _buildMenuOption(
              icon: Icons.shopping_cart_outlined,
              label: 'Reorder',
              onTap: () {
                ctx.pop();
                context.pushNamed(
                  RouteNames.nProductDetails,
                  pathParameters: {'id': order.listingId},
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.replay_outlined,
              label: 'Return Request',
              onTap: () {
                ctx.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Return request submitted for Order #${order.id}',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.cancel_outlined,
              label: 'Cancel Order',
              isDestructive: true,
              onTap: () {
                ctx.pop();
                _confirmCancelOrder(order);
              },
            ),
            _buildMenuOption(
              icon: Icons.archive_outlined,
              label: 'Archive',
              onTap: () {
                ctx.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Order #${order.id} archived',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmCancelOrder(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Order',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel Order #${order.id}? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Keep Order',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Order #${order.id} cancelled',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Cancel Order',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.onSurface;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orders = ref.read(orderProvider.notifier).getFilteredOrders();
    final selectedTabIndex = switch (orderState.selectedTab) {
      OrderTab.all => 0,
      OrderTab.processing => 1,
      OrderTab.shipped => 2,
      OrderTab.delivered => 3,
    };

    return SafeArea(
      child: Column(
        children: [
          AppPageHeader(
            title: 'Orders',
            subtitle: '${orders.length} order${orders.length == 1 ? '' : 's'}',
            actions: [
              IconButton(
                onPressed: () => context.pushNamed(RouteNames.nNotifications),
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.onSurface, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppTabBar(
            tabs: _tabs,
            selectedIndex: selectedTabIndex,
            onSelected: _onTabSelected,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: orderState.orders.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (_) => orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildOrderCard(orders[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final label = switch (ref.read(orderProvider).selectedTab) {
      OrderTab.all => 'orders',
      OrderTab.processing => 'processing orders',
      OrderTab.shipped => 'shipped orders',
      OrderTab.delivered => 'delivered orders',
    };
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
                Icons.receipt_long_outlined,
                size: 36,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No $label yet',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you place orders, they will appear here.',
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

  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _statusColor(order.status);
    final formattedDate =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.nOrderDetails,
        pathParameters: {'id': order.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _orderIcon(order.status),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
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
                              order.listingTitle,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _statusLabel(order.status),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.sellerId,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order #${order.id}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.outlineVariant, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.outline),
                const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.shippingAddress,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.outline),
                const SizedBox(width: 8),
                Text(
                  'Estimated: $formattedDate',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(
                      RouteNames.nTrackOrder,
                      pathParameters: {'id': order.id},
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_shipping_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Track Order',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(
                      RouteNames.nConversation,
                      pathParameters: {'id': order.sellerId},
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 16, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text(
                            'Contact',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showOrderMenu(order),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.more_vert,
                        size: 20, color: AppColors.outline),
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
