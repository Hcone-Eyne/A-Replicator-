import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                  ),
                  Expanded(
                    child: Text(
                      'Reviews',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Rating Summary
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  // Big Rating
                  Column(
                    children: [
                      Text(
                        '4.0',
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
                        '128 reviews',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Rating Bars
                  Expanded(
                    child: Column(
                      children: List.generate(5, (index) {
                        final rating = 5 - index;
                        final percentage = [0.6, 0.2, 0.1, 0.05, 0.05][index];
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
            ),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _buildFilterTab('All Reviews', 0),
                  const SizedBox(width: 8),
                  _buildFilterTab('With Photos', 1),
                  const SizedBox(width: 8),
                  _buildFilterTab('5 Stars', 2),
                ],
              ),
            ),

            // Reviews List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
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
              Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.outline),
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
}
