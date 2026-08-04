import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../messaging/presentation/providers/messaging_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/models/listing_model.dart';
import '../providers/listing_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id != null) {
        ref.read(listingProvider.notifier).getListingById(widget.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listingState = ref.watch(listingProvider);
    final listing = listingState.selectedListing.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: listingState.selectedListing.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load listing',
                style: GoogleFonts.inter(
                    fontSize: 16, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: Text('Go Back',
                    style: GoogleFonts.inter(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        data: (_) {
          if (listing == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Listing not found',
                    style: GoogleFonts.inter(
                        fontSize: 16, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text('Go Back',
                        style: GoogleFonts.inter(color: AppColors.primary)),
                  ),
                ],
              ),
            );
          }

          final isFavorited = listing.favoriteCount > 0;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.surfaceBright,
                pinned: true,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share coming soon')),
                      );
                    },
                    icon: const Icon(Icons.share_outlined,
                        color: AppColors.onSurface),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(listingProvider.notifier)
                          .toggleFavorite(listing.id);
                    },
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? AppColors.error : AppColors.onSurface,
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GestureDetector(
                        onTap: () => context.pushNamed(
                          RouteNames.nImageGallery,
                          pathParameters: {'id': listing.id},
                        ),
                        child: const Center(
                          child: Icon(Icons.headphones,
                              color: AppColors.primary, size: 80),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedImageIndex = index),
                            child: Container(
                              width: 64,
                              height: 64,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedImageIndex == index
                                      ? AppColors.primary
                                      : AppColors.outlineVariant,
                                  width:
                                      _selectedImageIndex == index ? 2 : 1,
                                ),
                              ),
                              child: const Icon(Icons.headphones,
                                  color: AppColors.primary, size: 24),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              listing.title,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            '\$${listing.price.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(
                              5,
                              (index) => Icon(
                                    index < 4 ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  )),
                          const SizedBox(width: 8),
                          Text(
                            '4.0 (128 reviews)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Color',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildColorOption(0, AppColors.primary),
                          const SizedBox(width: 8),
                          _buildColorOption(1, AppColors.onSurface),
                          const SizedBox(width: 8),
                          _buildColorOption(2, AppColors.outline),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        listing.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Features',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFeature(Icons.category, listing.category),
                      if (listing.condition.isNotEmpty)
                        _buildFeature(Icons.info_outline, listing.condition),
                      if (listing.location.isNotEmpty)
                        _buildFeature(
                            Icons.location_on_outlined, listing.location),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.pushNamed(
                          RouteNames.nSellerProfile,
                          pathParameters: {'id': listing.sellerId},
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppColors.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.store,
                                    color: AppColors.onPrimary, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Seller',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    Text(
                                      'View seller profile',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: AppColors.outline),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed(
                              RouteNames.nProductReviews,
                              pathParameters: {'id': listing.id},
                            ),
                            child: Text(
                              'See All',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildReviewCard(
                        name: 'Sarah M.',
                        rating: 5,
                        date: 'Oct 24, 2023',
                        review:
                            'Amazing sound quality! The noise cancellation is top-notch.',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: listing != null
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                        color: AppColors.outlineVariant, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _contactSeller(listing),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        side: const BorderSide(
                            color: AppColors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Contact Seller',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _buyNow(listing),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Buy Now',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Future<void> _contactSeller(ListingModel listing) async {
    final conversation = await ref
        .read(messagingProvider.notifier)
        .createConversation(
          otherUserId: listing.sellerId,
          productId: listing.id,
          productTitle: listing.title,
          productImage: listing.images.isNotEmpty ? listing.images.first : '',
        );
    if (!mounted) return;
    if (conversation == null) {
      AppSnackbar.show(context, 'Could not start a conversation. Please try again.');
      return;
    }
    context.pushNamed(
      RouteNames.nConversation,
      pathParameters: {'id': conversation.id},
    );
  }

  Future<void> _buyNow(ListingModel listing) async {
    final currentUserId =
        ref.read(profileProvider).userProfile.valueOrNull?.id;
    if (currentUserId != null && listing.sellerId == currentUserId) {
      AppSnackbar.show(context, 'You cannot buy your own listing');
      return;
    }

    final order = await ref
        .read(orderProvider.notifier)
        .createOrder(listingId: listing.id);
    if (!mounted) return;
    if (order == null) {
      AppSnackbar.show(context, 'Could not place the order. Please try again.');
      return;
    }
    AppSnackbar.show(context, 'Order placed successfully');
    context.pushNamed(
      RouteNames.nTrackOrder,
      pathParameters: {'id': order.id},
    );
  }

  Widget _buildColorOption(int index, Color color) {    final isSelected = _selectedColor == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = index),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required String date,
    required String review,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  name[0],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                      date,
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
                        )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
