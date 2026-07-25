import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  int _selectedTab = 0;
  int _selectedReviewFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.surfaceBright,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
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

          // Profile Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 3,
                      ),
                    ),
                    child: const Icon(Icons.store, color: AppColors.onPrimary, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'TechHub Store',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
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
                  const SizedBox(height: 16),

                  // Stats
                  Row(
                    children: [
                      _buildStat('4.8', 'Rating'),
                      const SizedBox(width: 12),
                      _buildStat('2.4k', 'Sales'),
                      const SizedBox(width: 12),
                      _buildStat('98%', 'Positive'),
                      const SizedBox(width: 12),
                      _buildStat('2yr', 'Member'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  Text(
                    'Premium electronics and accessories. Authentic products with warranty. Fast shipping worldwide.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onSurface,
                            side: const BorderSide(color: AppColors.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Message',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Follow',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab Headers
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: _selectedTab == 0
                            ? const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                              )
                            : null,
                        child: Text(
                          'Listings',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedTab == 0 ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: _selectedTab == 1
                            ? const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                              )
                            : null,
                        child: Text(
                          'Reviews',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
                            color: _selectedTab == 1 ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          if (_selectedTab == 0) ...[
            // Product Grid
            SliverPadding(
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
                    return _buildProductCard(
                      title: _getProductName(index),
                      price: _getProductPrice(index),
                      icon: _getProductIcon(index),
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
          ] else ...[
            // Reviews Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildRatingSummary(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    _buildReviewFilterTab('All Reviews', 0),
                    const SizedBox(width: 8),
                    _buildReviewFilterTab('With Photos', 1),
                    const SizedBox(width: 8),
                    _buildReviewFilterTab('5 Stars', 2),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildReviewCard(
                    name: 'Sarah M.',
                    rating: 5,
                    date: 'Oct 24, 2023',
                    review: 'Amazing sound quality! The noise cancellation is top-notch. Highly recommend for music lovers.',
                    hasPhoto: true,
                  ),
                  const SizedBox(height: 12),
                  _buildReviewCard(
                    name: 'James L.',
                    rating: 4,
                    date: 'Oct 22, 2023',
                    review: 'Great headphones overall. Comfortable for long listening sessions. Battery life is impressive.',
                    hasPhoto: false,
                  ),
                  const SizedBox(height: 12),
                  _buildReviewCard(
                    name: 'Emily R.',
                    rating: 5,
                    date: 'Oct 20, 2023',
                    review: 'Best purchase I\'ve made this year. Crystal clear audio and the build quality is premium.',
                    hasPhoto: true,
                  ),
                  const SizedBox(height: 12),
                  _buildReviewCard(
                    name: 'Michael K.',
                    rating: 4,
                    date: 'Oct 18, 2023',
                    review: 'Solid headphones. The ANC could be slightly better but overall great value for the price.',
                    hasPhoto: false,
                  ),
                  const SizedBox(height: 12),
                  _buildReviewCard(
                    name: 'Lisa T.',
                    rating: 3,
                    date: 'Oct 15, 2023',
                    review: 'Good sound but a bit tight on my head after wearing for a few hours. Might not be for everyone.',
                    hasPhoto: false,
                  ),
                ]),
              ),
            ),
          ],
        ],
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

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '4.8',
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                )),
              ),
              const SizedBox(height: 4),
              Text(
                '2.4k reviews',
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
                final percentage = [0.72, 0.18, 0.06, 0.03, 0.01][index];
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

  Widget _buildReviewFilterTab(String label, int index) {
    final isSelected = _selectedReviewFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedReviewFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
          border: isSelected ? null : Border.all(color: AppColors.outlineVariant),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required String date,
    required String review,
    required bool hasPhoto,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
                radius: 18,
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
                children: List.generate(5, (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 14,
                )),
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
          Row(
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
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
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
                child: Icon(icon, color: AppColors.primary, size: 32),
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
      ),
    );
  }

  String _getProductName(int index) {
    final names = [
      'Wireless Headphones',
      'Smart Watch Pro',
      'USB-C Hub',
      'Webcam HD',
      'Desk Lamp',
      'Monitor Arm',
    ];
    return names[index % names.length];
  }

  String _getProductPrice(int index) {
    final prices = ['\$299', '\$449', '\$69', '\$129', '\$79', '\$199'];
    return prices[index % prices.length];
  }

  IconData _getProductIcon(int index) {
    final icons = [
      Icons.headphones, Icons.watch, Icons.usb,
      Icons.videocam, Icons.lightbulb, Icons.desktop_windows,
    ];
    return icons[index % icons.length];
  }
}
