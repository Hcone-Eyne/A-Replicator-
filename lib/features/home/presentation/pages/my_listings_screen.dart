import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/navigation/app_page_header.dart';
import '../../../../core/widgets/navigation/app_tab_bar.dart';
import '../../../../core/widgets/inputs/app_search_field.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../home/data/models/listing_model.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;

  static const _filterLabels = ['All', 'Active', 'Reserved', 'Sold', 'Expired'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getMyListings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ListingModel> get _filteredListings {
    final state = ref.watch(profileProvider);
    var listings = state.myListings.valueOrNull ?? [];

    if (_searchQuery.isNotEmpty) {
      listings = listings
          .where((l) => l.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilter > 0) {
      final targetStatus = ListingStatus.values[_selectedFilter - 1];
      listings = listings.where((l) => l.status == targetStatus).toList();
    }

    return listings;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final listings = _filteredListings;

    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'My Listings',
              onBack: () => context.pop(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              actions: [
                IconButton(
                  onPressed: () => context.pushNamed(RouteNames.nNotifications),
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Search your listings...',
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const SizedBox(height: 12),
            AppTabBar(
              tabs: _filterLabels,
              selectedIndex: _selectedFilter,
              onSelected: (index) => setState(() => _selectedFilter = index),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.myListings.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (_) => listings.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: listings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) => _buildListingCard(listings[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.nCreateListing),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.outline.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No listings match your search' : 'No listings yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty ? 'Try a different search term' : 'Create your first listing to get started',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.outline,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pushNamed(RouteNames.nCreateListing),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Create Listing',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListingCard(ListingModel listing) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildImageSection(listing),
          _buildCardContent(listing),
        ],
      ),
    );
  }

  Widget _buildImageSection(ListingModel listing) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _iconForCategory(listing.category),
              size: 48,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _buildStatusBadge(listing.status),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _showMoreOptionsSheet(listing),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, size: 18, color: AppColors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ListingStatus status) {
    final (label, bgColor, textColor, dotColor) = switch (status) {
      ListingStatus.active => (
        'Active',
        AppColors.tertiaryFixed,
        AppColors.onTertiaryFixed,
        AppColors.onTertiaryFixedVariant,
      ),
      ListingStatus.reserved => (
        'Reserved',
        AppColors.surfaceVariant,
        AppColors.onSurfaceVariant,
        AppColors.onSurfaceVariant,
      ),
      ListingStatus.sold => (
        'Sold',
        AppColors.primaryContainer,
        AppColors.onPrimaryContainer,
        AppColors.onPrimaryContainer,
      ),
      ListingStatus.expired => (
        'Expired',
        AppColors.secondaryContainer,
        AppColors.onSecondaryContainer,
        AppColors.onSecondaryContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(ListingModel listing) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  listing.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                listing.price > 0 ? '\$${listing.price.toStringAsFixed(0)}' : '\$ --',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: listing.status == ListingStatus.sold
                      ? AppColors.outline
                      : AppColors.primary,
                  decoration: listing.status == ListingStatus.sold
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStat(Icons.visibility, '${listing.viewCount}'),
              const SizedBox(width: 16),
              _buildStat(Icons.favorite, '${listing.favoriteCount}'),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButtons(listing),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.outline),
        const SizedBox(width: 6),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ListingModel listing) {
    return switch (listing.status) {
      ListingStatus.active => Row(
          children: [
            Expanded(
              child: _buildButton(
                label: 'Edit',
                icon: Icons.edit,
                variant: _ButtonVariant.secondary,
                onPressed: () => context.pushNamed(
                  RouteNames.nCreateListing,
                  queryParameters: {'id': listing.id},
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                label: 'Analytics',
                icon: Icons.analytics,
                variant: _ButtonVariant.primary,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics coming soon')),
                ),
              ),
            ),
          ],
        ),
      ListingStatus.sold => SizedBox(
          width: double.infinity,
          child: _buildButton(
            label: 'View Order Details',
            icon: Icons.receipt_long,
            variant: _ButtonVariant.outline,
            onPressed: () => context.pushNamed(
              RouteNames.nOrderDetails,
              pathParameters: {'id': listing.id},
            ),
          ),
        ),
      ListingStatus.reserved => Row(
          children: [
            Expanded(
              child: _buildButton(
                label: 'Edit',
                icon: Icons.edit,
                variant: _ButtonVariant.secondary,
                onPressed: () => context.pushNamed(
                  RouteNames.nCreateListing,
                  queryParameters: {'id': listing.id},
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                label: 'Mark as Sold',
                icon: Icons.check_circle,
                variant: _ButtonVariant.primary,
                onPressed: () {
                  ref.read(profileProvider.notifier).markAsSold(listing.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing marked as sold')),
                  );
                },
              ),
            ),
          ],
        ),
      ListingStatus.expired => Row(
          children: [
            Expanded(
              child: _buildButton(
                label: 'Relist',
                icon: Icons.refresh,
                variant: _ButtonVariant.primary,
                onPressed: () => context.pushNamed(
                  RouteNames.nCreateListing,
                  queryParameters: {'id': listing.id},
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                label: 'Delete',
                icon: Icons.delete_outline,
                variant: _ButtonVariant.outline,
                onPressed: () => _showDeleteConfirmation(listing),
              ),
            ),
          ],
        ),
    };
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required _ButtonVariant variant,
    required VoidCallback onPressed,
  }) {
    final (bgColor, fgColor, borderColor) = switch (variant) {
      _ButtonVariant.primary => (AppColors.primary, AppColors.onPrimary, Colors.transparent),
      _ButtonVariant.secondary => (AppColors.secondaryContainer, AppColors.onSecondaryContainer, Colors.transparent),
      _ButtonVariant.outline => (Colors.transparent, AppColors.outline, AppColors.outlineVariant),
    };

    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          side: borderColor != Colors.transparent ? BorderSide(color: borderColor) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptionsSheet(ListingModel listing) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _buildSheetOption(
                icon: Icons.edit,
                label: 'Edit',
                onTap: () {
                  context.pop();
                  context.pushNamed(
                    RouteNames.nCreateListing,
                    queryParameters: {'id': listing.id},
                  );
                },
              ),
              _buildSheetOption(
                icon: Icons.content_copy,
                label: 'Duplicate',
                onTap: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing duplicated')),
                  );
                },
              ),
              _buildSheetOption(
                icon: Icons.archive,
                label: 'Archive',
                onTap: () {
                  context.pop();
                  ref.read(profileProvider.notifier).archiveListing(listing.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing archived')),
                  );
                },
              ),
              _buildSheetOption(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppColors.error,
                onTap: () {
                  context.pop();
                  _showDeleteConfirmation(listing);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.onSurfaceVariant, size: 22),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.onSurface,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  void _showDeleteConfirmation(ListingModel listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Listing',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${listing.title}"? This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(profileProvider.notifier).deleteListing(listing.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted')),
              );
            },
            child: Text(
              'Delete',
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

  IconData _iconForCategory(String category) {
    return switch (category.toLowerCase()) {
      'electronics' => Icons.devices,
      'home' => Icons.home_outlined,
      'furniture' => Icons.chair,
      'fashion' => Icons.checkroom,
      'vehicles' => Icons.directions_car,
      _ => Icons.inventory_2_outlined,
    };
  }

}

enum _ButtonVariant { primary, secondary, outline }
