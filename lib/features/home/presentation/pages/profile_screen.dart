import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/media/app_avatar.dart';
import '../../../../core/widgets/cards/app_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    ref.listen<ProfileState>(profileProvider, (prev, next) {
      final error = next.userProfile.error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString()), backgroundColor: AppColors.error),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: profileState.userProfile.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Profile',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.pushNamed(RouteNames.nSettings),
                        icon: const Icon(Icons.settings_outlined, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: AppCard(
                    padding: const EdgeInsets.all(20),
                    border: Border.all(color: AppColors.outlineVariant),
                    child: Column(
                      children: [
                        AppAvatar(
                          imageUrl: user?.avatarUrl,
                          name: user?.name,
                          size: AppAvatarSize.lg,
                          isVerified: user?.isVerified ?? false,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'Guest',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        if (user?.location.isNotEmpty ?? false) ...[
                          const SizedBox(height: 4),
                          Text(
                            user!.location,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStat('${user?.listingsCount ?? 0}', 'Listings'),
                            const SizedBox(width: 12),
                            _buildStat('${user?.salesCount ?? 0}', 'Sales'),
                            const SizedBox(width: 12),
                            _buildStat('${user?.following.length ?? 0}', 'Following'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.inventory_2_outlined,
                        label: 'My Listings',
                        onTap: () => context.pushNamed(RouteNames.nMyListings),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite_outline,
                        label: 'Saved',
                        onTap: () => context.pushNamed(RouteNames.nSaved),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.chat_bubble_outline,
                        label: 'Messages',
                        onTap: () => context.pushNamed(RouteNames.nMessages),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () => context.pushNamed(RouteNames.nNotifications),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Purchases',
                        onTap: () => context.pushNamed(RouteNames.nOrders),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.star_outline,
                        label: 'My Reviews',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reviews coming soon')),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLogoutButton(context, ref),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: Border.all(color: AppColors.outlineVariant),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: AppCard(
        onTap: () => _confirmLogout(context, ref),
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: AppColors.errorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              ctx.pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.goNamed(RouteNames.nLogin);
              }
            },
            child: Text(
              'Logout',
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
}
