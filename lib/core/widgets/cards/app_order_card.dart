import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

class AppOrderCard extends StatelessWidget {
  const AppOrderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusColor,
    this.icon,
    this.onTap,
    this.onTrack,
    this.onContact,
  });

  final String title;
  final String subtitle;
  final String orderId;
  final String date;
  final String status;
  final Color statusColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildInfo(),
            if (onTrack != null || onContact != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.outlineVariant),
              const SizedBox(height: 12),
              _buildActions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(icon, size: 22, color: AppColors.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.pillAll,
          ),
          child: Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        _buildInfoChip(Icons.receipt_outlined, orderId),
        const SizedBox(width: 16),
        _buildInfoChip(Icons.calendar_today_outlined, date),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        if (onTrack != null)
          Expanded(
            child: _buildActionButton(
              label: 'Track Order',
              icon: Icons.local_shipping_outlined,
              color: AppColors.primary,
              onTap: onTrack,
            ),
          ),
        if (onTrack != null && onContact != null) const SizedBox(width: 12),
        if (onContact != null)
          Expanded(
            child: _buildActionButton(
              label: 'Contact',
              icon: Icons.chat_bubble_outline,
              color: AppColors.secondary,
              onTap: onContact,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.mdAll,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
