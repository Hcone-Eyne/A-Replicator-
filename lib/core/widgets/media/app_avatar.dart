import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

enum AppAvatarSize { sm, md, lg }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.md,
    this.isOnline = false,
    this.isVerified = false,
    this.onTap,
  });

  final String? imageUrl;
  final String? name;
  final AppAvatarSize size;
  final bool isOnline;
  final bool isVerified;
  final VoidCallback? onTap;

  double get _dimension {
    switch (size) {
      case AppAvatarSize.sm:
        return 36;
      case AppAvatarSize.md:
        return 48;
      case AppAvatarSize.lg:
        return 64;
    }
  }

  double get _fontSize {
    switch (size) {
      case AppAvatarSize.sm:
        return 13;
      case AppAvatarSize.md:
        return 16;
      case AppAvatarSize.lg:
        return 22;
    }
  }

  double get _onlineDotSize {
    switch (size) {
      case AppAvatarSize.sm:
        return 8;
      case AppAvatarSize.md:
        return 10;
      case AppAvatarSize.lg:
        return 12;
    }
  }

  double get _badgeSize {
    switch (size) {
      case AppAvatarSize.sm:
        return 14;
      case AppAvatarSize.md:
        return 16;
      case AppAvatarSize.lg:
        return 20;
    }
  }

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Color get _backgroundColor {
    if (name == null || name!.isEmpty) return AppColors.surfaceContainerHigh;
    final hash = name.hashCode;
    final colors = [
      AppColors.primaryContainer,
      AppColors.secondaryContainer,
      const Color(0xFFE8D5F5),
      const Color(0xFFD5E8F5),
      const Color(0xFFF5E8D5),
      const Color(0xFFD5F5E8),
    ];
    return colors[hash.abs() % colors.length];
  }

  Color get _textColor {
    if (name == null || name!.isEmpty) return AppColors.onSurfaceVariant;
    final hash = name.hashCode;
    final colors = [
      AppColors.onPrimaryContainer,
      AppColors.onSecondaryContainer,
      const Color(0xFF5B2C8A),
      const Color(0xFF2C5B8A),
      const Color(0xFF8A5B2C),
      const Color(0xFF2C8A5B),
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _dimension,
            height: _dimension,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _backgroundColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildContent(),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: _onlineDotSize,
                height: _onlineDotSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
              ),
            ),
          if (isVerified)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: _badgeSize,
                height: _badgeSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  size: _badgeSize * 0.6,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitials(),
      );
    }
    return _buildInitials();
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _initials,
        style: GoogleFonts.inter(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
