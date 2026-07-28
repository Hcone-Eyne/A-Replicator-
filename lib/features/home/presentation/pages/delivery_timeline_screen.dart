import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class DeliveryTimelineScreen extends StatelessWidget {
  const DeliveryTimelineScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBright,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: Text(
          'Delivery Timeline',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.nNotifications),
            icon: const Icon(Icons.notifications, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header Card
            _buildOrderHeaderCard(),
            const SizedBox(height: 24),

            // Vertical Timeline
            _buildVerticalTimeline(),
            const SizedBox(height: 32),

            // Support Section
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER ID',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#MP-8829-0122',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'In Transit',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceContainer, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surfaceContainerLow,
                ),
                child: const Icon(Icons.keyboard, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Mechanical Keyboard v2',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimated Arrival: Oct 28, 2023',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTimeline() {
    return Column(
      children: [
        _buildTimelineEntry(
          icon: Icons.check_circle,
          title: 'Order Placed',
          time: 'Oct 24, 09:15 AM',
          description: 'We have received your order and it is being processed.',
          isCompleted: true,
          isActive: false,
          isFirst: true,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.payments,
          title: 'Payment Confirmed',
          time: 'Oct 24, 09:45 AM',
          description: 'Payment verified via Mastercard ending in 4421.',
          isCompleted: true,
          isActive: false,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.storefront,
          title: 'Seller Accepted',
          time: 'Oct 24, 11:30 AM',
          description: 'The seller has acknowledged and is preparing your items.',
          isCompleted: true,
          isActive: false,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.inventory_2,
          title: 'Packed',
          time: 'Oct 25, 02:00 PM',
          description: 'Your item has been securely packed and is ready for pickup.',
          isCompleted: true,
          isActive: false,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.local_shipping,
          title: 'Shipped',
          time: 'Oct 26, 08:45 AM',
          description: 'Package left the sort facility in Chicago, IL. In transit to destination.',
          isCompleted: false,
          isActive: true,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.delivery_dining,
          title: 'Out for Delivery',
          time: 'Pending',
          description: 'Expect a delivery representative at your doorstep soon.',
          isCompleted: false,
          isActive: false,
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineEntry(
          icon: Icons.verified,
          title: 'Delivered',
          time: 'Expected Oct 28',
          description: 'Package will be handed over to you or left at your secure location.',
          isCompleted: false,
          isActive: false,
          isFirst: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineEntry({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    required bool isCompleted,
    required bool isActive,
    required bool isFirst,
    required bool isLast,
  }) {
    final isPending = !isCompleted && !isActive;
    final circleColor = isCompleted || isActive
        ? (isActive ? AppColors.primary : AppColors.primaryContainer)
        : AppColors.surfaceContainerHigh;
    final textColor = isCompleted || isActive ? AppColors.primary : AppColors.secondary;
    final descOpacity = isPending ? 0.6 : 1.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Circle
                Container(
                  width: isActive ? 48 : 44,
                  height: isActive ? 48 : 44,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(color: AppColors.primaryFixed, width: 4)
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isCompleted || isActive
                        ? (isActive ? AppColors.onPrimary : AppColors.onPrimaryContainer)
                        : AppColors.secondary,
                  ),
                ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? AppColors.primaryContainer
                          : AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isActive ? 6 : 4,
                bottom: isLast ? 0 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: isActive ? 16 : 16,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                            color: isActive ? AppColors.primary : textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                          color: isActive ? AppColors.primary : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Opacity(
                    opacity: descOpacity,
                    child: Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need Help?',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our support team is available 24/7 for any questions regarding your delivery.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support contact coming soon')),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.headset_mic, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Contact Support',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
