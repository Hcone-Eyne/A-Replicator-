import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoadingSkeletonScreen extends StatefulWidget {
  const LoadingSkeletonScreen({super.key});

  @override
  State<LoadingSkeletonScreen> createState() => _LoadingSkeletonScreenState();
}

class _LoadingSkeletonScreenState extends State<LoadingSkeletonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkeletonBox(100, 24, _animation.value),
                        Row(
                          children: [
                            _buildSkeletonCircle(40, _animation.value),
                            const SizedBox(width: 8),
                            _buildSkeletonCircle(40, _animation.value),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildSkeletonBox(double.infinity, 48, _animation.value),
                  ),
                ),

                // Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        _buildSkeletonBox(80, 32, _animation.value),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(100, 32, _animation.value),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(70, 32, _animation.value),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(90, 32, _animation.value),
                      ],
                    ),
                  ),
                ),

                // Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildSkeletonBox(double.infinity, 160, _animation.value),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: _buildSkeletonBox(140, 20, _animation.value),
                  ),
                ),

                // Product Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Expanded(child: _buildSkeletonProductCard(_animation.value)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSkeletonProductCard(_animation.value)),
                      ],
                    ),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: _buildSkeletonBox(180, 20, _animation.value),
                  ),
                ),

                // Activity Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildSkeletonActivityCard(_animation.value),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonBox(double width, double height, double opacity) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildSkeletonCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSkeletonProductCard(double opacity) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(double.infinity, 100, opacity),
          const SizedBox(height: 8),
          _buildSkeletonBox(double.infinity, 14, opacity),
          const SizedBox(height: 6),
          _buildSkeletonBox(80, 14, opacity),
        ],
      ),
    );
  }

  Widget _buildSkeletonActivityCard(double opacity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          _buildSkeletonCircle(48, opacity),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(160, 14, opacity),
                const SizedBox(height: 6),
                _buildSkeletonBox(120, 12, opacity),
              ],
            ),
          ),
          _buildSkeletonBox(60, 28, opacity),
        ],
      ),
    );
  }
}
