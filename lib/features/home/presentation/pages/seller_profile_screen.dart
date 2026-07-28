import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/media/app_avatar.dart';
import '../../../../core/widgets/cards/app_card.dart';
import '../../../../core/widgets/navigation/app_tab_bar.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../home/presentation/providers/listing_provider.dart';

class SellerProfileScreen extends ConsumerStatefulWidget {
  const SellerProfileScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  int _selectedTab = 0;
  int _selectedReviewFilter = 0;
  static const _reviewFilterLabels = ['All Reviews', 'With Photos', '5 Stars'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sellerId = widget.id ?? '';
      ref.read(sellerProvider.notifier).getSellerProfile(sellerId);
      ref.read(sellerProvider.notifier).getReviews(sellerId);
      ref.read(listingProvider.notifier).getListings();
    });
  }

  List<dynamic> get _filteredReviews {
    final reviews = ref.read(sellerProvider).reviews.valueOrNull ?? [];
    switch (_selectedReviewFilter) {
      case 1:
        return reviews.where((r) => r.hasPhoto).toList();
      case 2:
        return reviews.where((r) => r.rating == 5).toList();
      default:
        return reviews;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sellerState = ref.watch(sellerProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: sellerState.seller.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (seller) => CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.surfaceBright,
              pinned: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              ),
              title: Text(
                'Seller Profile',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              centerTitle: true,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppAvatar(
                      imageUrl: seller?.avatarUrl,
                      name: seller?.name ?? '',
                      size: AppAvatarSize.lg,
                      isVerified: seller?.isVerified ?? false,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      seller?.name ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    if (seller?.isVerified ?? false) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified, color: AppColors.primary, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Seller',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _buildStat('${seller?.rating ?? 0}', 'Rating'),
                        const SizedBox(width: 12),
                        _buildStat('${seller?.salesCount ?? 0}', 'Sales'),
                        const SizedBox(width: 12),
                        _buildStat('${seller?.positivePercent ?? 0}%', 'Positive'),
                        const SizedBox(width: 12),
                        _buildStat(seller?.memberDuration ?? '', 'Member'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (seller?.bio.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          seller!.bio,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Message',
                            variant: AppButtonVariant.outline,
                            fullWidth: true,
                            onPressed: () {
                              final sellerId = widget.id ?? '';
                              context.pushNamed(
                                RouteNames.nConversation,
                                pathParameters: {'id': sellerId},
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: sellerState.isFollowing ? 'Unfollow' : 'Follow',
                            variant: sellerState.isFollowing
                                ? AppButtonVariant.outline
                                : AppButtonVariant.primary,
                            fullWidth: true,
                            onPressed: _toggleFollow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
                ),
                child: Row(
                  children: [
                    _buildTab('Listings', 0),
                    _buildTab('Reviews', 1),
                  ],
                ),
              ),
            ),

            if (_selectedTab == 0) ...[
              ref.watch(listingProvider).listings.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
                ),
                data: (allListings) {
                  final sellerListings = allListings
                      .where((l) => l.sellerId == widget.id)
                      .toList();
                  if (sellerListings.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No listings yet',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final listing = sellerListings[index];
                          return _buildProductCard(
                            title: listing.title,
                            price: '\$${listing.price.toStringAsFixed(0)}',
                            onTap: () => context.pushNamed(
                              RouteNames.nProductDetails,
                              pathParameters: {'id': listing.id},
                            ),
                          );
                        },
                        childCount: sellerListings.length,
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildRatingSummary(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: AppTabBar(
                    tabs: _reviewFilterLabels,
                    selectedIndex: _selectedReviewFilter,
                    onSelected: (index) => setState(() => _selectedReviewFilter = index),
                  ),
                ),
              ),
              _filteredReviews.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No reviews match this filter',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final review = _filteredReviews[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildReviewCard(
                                name: review.userName,
                                rating: review.rating,
                                date: review.date,
                                review: review.text,
                                hasPhoto: review.hasPhoto,
                              ),
                            );
                          },
                          childCount: _filteredReviews.length,
                        ),
                      ),
                    ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleFollow() {
    final notifier = ref.read(sellerProvider.notifier);
    final wasFollowing = ref.read(sellerProvider).isFollowing;
    final sellerId = widget.id ?? '';

    if (wasFollowing) {
      notifier.unfollow(sellerId);
    } else {
      notifier.follow(sellerId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasFollowing ? 'Unfollowed' : 'Following',
          style: GoogleFonts.inter(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
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
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: isSelected
              ? const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                )
              : null,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    final reviews = ref.read(sellerProvider).reviews.valueOrNull ?? [];
    final seller = ref.read(sellerProvider).seller.valueOrNull;
    final totalReviews = reviews.length;
    final avgRating = seller?.rating ?? 0;

    final ratingCounts = [0, 0, 0, 0, 0];
    for (final r in reviews) {
      if (r.rating >= 1 && r.rating <= 5) {
        ratingCounts[r.rating - 1]++;
      }
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: AppColors.outlineVariant),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < avgRating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalReviews reviews',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final rating = 5 - index;
                final count = ratingCounts[rating - 1];
                final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: AppColors.outlineVariant,
                          valueColor: const AlwaysStoppedAnimation(Colors.amber),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required DateTime date,
    required String review,
    required bool hasPhoto,
  }) {
    final formattedDate =
        '${date.month}/${date.day}/${date.year}';

    return AppCard(
      padding: const EdgeInsets.all(14),
      border: Border.all(color: AppColors.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: name,
                size: AppAvatarSize.sm,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          if (hasPhoto) ...[
            const SizedBox(height: 10),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.photo, color: AppColors.outline, size: 24),
            ),
          ],
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanks for your feedback!')),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.outline),
                const SizedBox(width: 4),
                Text(
                  'Helpful',
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
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      border: Border.all(color: AppColors.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.outline, size: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
