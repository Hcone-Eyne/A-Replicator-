import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/navigation/navigation_utils.dart';
import '../../../../core/widgets/navigation/app_page_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

  final _filters = ['All', 'Orders', 'Messages', 'Offers', 'Listings', 'System'];

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read')),
                    );
                  },
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterChips(),
                    const SizedBox(height: 24),
                    _buildSection('Today', [
                      _NotificationData(
                        id: '1',
                        icon: Icons.sell_outlined,
                        iconBgColor: AppColors.tertiaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.onTertiaryContainer,
                        title: 'Apple Watch Ultra 2',
                        time: '2m ago',
                        message: 'Your offer of \$2,100 was accepted by Julian Walters.',
                        hasActions: true,
                        actionLabel1: 'Complete Purchase',
                        actionLabel2: 'Decline',
                        hasDot: true,
                      ),
                      const _NotificationData(
                        id: '2',
                        icon: null,
                        iconBgColor: AppColors.surfaceVariant,
                        iconColor: Colors.transparent,
                        title: 'Alex Rivera',
                        time: '45m ago',
                        message: '"Is the price negotiable for the MacBook Pro?"',
                        isAvatar: true,
                        hasDot: true,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Yesterday', [
                      _NotificationData(
                        id: '3',
                        icon: Icons.local_shipping_outlined,
                        iconBgColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.primary,
                        title: 'Sony WH-1000XM5',
                        time: '1d ago',
                        message: 'Great news! Your order has been shipped and is on its way.',
                        hasTrackButton: true,
                      ),
                      _NotificationData(
                        id: '4',
                        icon: Icons.trending_down,
                        iconBgColor: AppColors.errorContainer.withValues(alpha: 0.2),
                        iconColor: AppColors.onErrorContainer,
                        title: 'Eames Lounge Chair',
                        time: '1d ago',
                        message: 'An item in your wishlist just dropped in price by 15%.',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Earlier', [
                      const _NotificationData(
                        id: '5',
                        icon: Icons.verified_user_outlined,
                        iconBgColor: AppColors.secondaryFixed,
                        iconColor: AppColors.primary,
                        title: 'Security Update',
                        time: '4d ago',
                        message: 'Your identity has been successfully verified. You now have full access to marketplace bidding.',
                      ),
                    ]),
                  ],
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
                color: isSelected ? AppColors.primaryContainer : AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSecondaryContainer,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<_NotificationData> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        ...notifications.map((n) => _buildNotificationCard(n)),
      ],
    );
  }

  Widget _buildNotificationCard(_NotificationData data) {
    return GestureDetector(
      onTap: () {
        if (data.title == 'Alex Rivera') {
          context.pushNamed(RouteNames.nConversation, pathParameters: {'id': data.id});
        } else if (data.title == 'Apple Watch Ultra 2') {
          context.pushNamed(RouteNames.nOfferNegotiation, pathParameters: {'id': data.id});
        } else if (data.title == 'Sony WH-1000XM5') {
          context.pushNamed(RouteNames.nTrackOrder, pathParameters: {'id': data.id});
        } else if (data.title == 'Eames Lounge Chair') {
          context.pushNamed(RouteNames.nProductDetails, pathParameters: {'id': data.id});
        }
      },
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
            _buildNotificationIcon(data),
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
                          data.title,
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
                        data.time,
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
                    data.message,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  if (data.hasActions) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.nOfferNegotiation, pathParameters: {'id': data.id});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            data.actionLabel1 ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.nProductDetails, pathParameters: {'id': data.id});
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.secondaryContainer,
                            foregroundColor: AppColors.onSecondaryContainer,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            side: BorderSide.none,
                          ),
                          child: Text(
                            data.actionLabel2 ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (data.hasTrackButton) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.nTrackOrder, pathParameters: {'id': data.id});
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.onSurface,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        side: const BorderSide(color: AppColors.outlineVariant),
                      ),
                      child: Text(
                        'Track Shipment',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (data.hasDot) ...[
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

  Widget _buildNotificationIcon(_NotificationData data) {
    if (data.isAvatar) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: data.iconBgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 24),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: data.iconBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(data.icon, color: data.iconColor, size: 24),
    );
  }
}

class _NotificationData {
  final String id;
  final IconData? icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String time;
  final String message;
  final bool hasActions;
  final String? actionLabel1;
  final String? actionLabel2;
  final bool hasTrackButton;
  final bool hasDot;
  final bool isAvatar;

  const _NotificationData({
    required this.id,
    this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.message,
    this.hasActions = false,
    this.actionLabel1,
    this.actionLabel2,
    this.hasTrackButton = false,
    this.hasDot = false,
    this.isAvatar = false,
  });
}
