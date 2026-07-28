import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, List<Map<String, String>>> _faqCategories = {
    'Account': [
      {
        'question': 'How do I create an account?',
        'answer': 'Tap on "Sign Up" on the login screen and follow the steps to create your account using your email or phone number.',
      },
      {
        'question': 'How do I reset my password?',
        'answer': 'Go to Settings > Change Password, or use the "Forgot Password" option on the login screen.',
      },
      {
        'question': 'How do I delete my account?',
        'answer': 'Go to Settings > Privacy & Security > Delete Account. Note that this action is irreversible.',
      },
    ],
    'Orders': [
      {
        'question': 'How do I track my order?',
        'answer': 'Go to Orders tab and tap on the order you want to track. You will see real-time tracking information.',
      },
      {
        'question': 'Can I cancel an order?',
        'answer': 'You can cancel an order before it is shipped. Go to Order Details and tap "Cancel Order".',
      },
      {
        'question': 'How do I return an item?',
        'answer': 'Go to Order Details and tap "Return Item". Follow the return instructions within 14 days of delivery.',
      },
    ],
    'Payments': [
      {
        'question': 'What payment methods are accepted?',
        'answer': 'We accept all major credit cards, debit cards, and digital wallets like Apple Pay and Google Pay.',
      },
      {
        'question': 'When will I be charged?',
        'answer': 'Your card is charged when the seller confirms your order. For pre-orders, you are charged upon shipment.',
      },
      {
        'question': 'How do I get a refund?',
        'answer': 'Refunds are processed within 5-7 business days after the return is received and inspected.',
      },
    ],
    'Shipping': [
      {
        'question': 'How long does shipping take?',
        'answer': 'Standard shipping takes 3-5 business days. Express shipping takes 1-2 business days.',
      },
      {
        'question': 'How much does shipping cost?',
        'answer': 'Shipping costs vary based on the seller and your location. Many sellers offer free shipping.',
      },
      {
        'question': 'Do you ship internationally?',
        'answer': 'Yes, many of our sellers ship internationally. Check the listing for shipping options.',
      },
    ],
  };

  Map<String, List<Map<String, String>>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _faqCategories;

    final filtered = <String, List<Map<String, String>>>{};
    for (final entry in _faqCategories.entries) {
      final matchingItems = entry.value.where((item) {
        final q = item['question']!.toLowerCase();
        final a = item['answer']!.toLowerCase();
        return q.contains(_searchQuery.toLowerCase()) ||
            a.contains(_searchQuery.toLowerCase());
      }).toList();
      if (matchingItems.isNotEmpty) {
        filtered[entry.key] = matchingItems;
      }
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBright,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBright,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help Center',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 24),
            _buildFaqSection(),
            const SizedBox(height: 24),
            _buildContactSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: GoogleFonts.inter(
          fontSize: 15,
          color: AppColors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search for help...',
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    final categories = _filteredCategories;

    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
              const SizedBox(height: 12),
              Text(
                'No results found',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try different keywords',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Frequently Asked Questions',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...categories.entries.map((entry) {
          return _buildFaqCategory(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildFaqCategory(String category, List<Map<String, String>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: AppColors.primary,
                size: 22,
              ),
            ),
            title: Text(
              category,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            children: items.map((item) {
              return _buildFaqItem(item['question']!, item['answer']!);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Account':
        return Icons.person_outline;
      case 'Orders':
        return Icons.receipt_long_outlined;
      case 'Payments':
        return Icons.credit_card_outlined;
      case 'Shipping':
        return Icons.local_shipping_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Support',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'support@flowapp.com',
            onTap: () async {
              final uri = Uri.parse('mailto:support@flowapp.com');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          const SizedBox(height: 8),
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+1 (800) 123-4567',
            onTap: () async {
              final uri = Uri.parse('tel:+18001234567');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          const SizedBox(height: 8),
          _buildContactItem(
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Available 24/7',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Live chat coming soon!', style: GoogleFonts.inter()),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}
