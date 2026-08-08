import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/router/route_guards.dart';
import '../../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/sign_up_screen.dart';
import '../../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../../features/security/presentation/pages/security_verification_screen.dart';
import '../../../features/home/presentation/pages/home_screen.dart';
import '../../../features/home/presentation/pages/explore_screen.dart';
import '../../../features/home/presentation/pages/search_results_screen.dart';
import '../../../features/home/presentation/pages/product_details_screen.dart';
import '../../../features/home/presentation/pages/image_gallery_screen.dart';
import '../../../features/home/presentation/pages/product_reviews_screen.dart';
import '../../../features/home/presentation/pages/seller_profile_screen.dart';
import '../../../features/home/presentation/pages/orders_screen.dart';
import '../../../features/home/presentation/pages/order_details_screen.dart';
import '../../../features/home/presentation/pages/invoice_screen.dart';
import '../../../features/home/presentation/pages/track_order_screen.dart';
import '../../../features/home/presentation/pages/delivery_timeline_screen.dart';
import '../../../features/home/presentation/pages/messages_screen.dart';
import '../../../features/home/presentation/pages/conversation_screen.dart';
import '../../../features/home/presentation/pages/offer_negotiation_screen.dart';
import '../../../features/home/presentation/pages/profile_screen.dart';
import '../../../features/home/presentation/pages/my_listings_screen.dart';
import '../../../features/home/presentation/pages/saved_screen.dart';
import '../../../features/home/presentation/pages/notifications_screen.dart';
import '../../../features/home/presentation/pages/create_listing_screen.dart';
import '../../../features/home/presentation/pages/upload_images_screen.dart';
import '../../../features/home/presentation/pages/listing_preview_screen.dart';
import '../../../features/home/presentation/pages/error_404_screen.dart';
import '../../../features/profile/presentation/pages/settings_screen.dart';
import '../../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../../features/profile/presentation/pages/change_password_screen.dart';
import '../../../features/profile/presentation/pages/saved_addresses_screen.dart';
import '../../../features/profile/presentation/pages/payment_methods_screen.dart';
import '../../../features/profile/presentation/pages/privacy_security_screen.dart';
import '../../../features/profile/presentation/pages/help_center_screen.dart';
import '../../../features/profile/presentation/pages/about_screen.dart';

class AppRouter {
  AppRouter._();

  static const splash = RouteNames.splash;
  static const login = RouteNames.login;
  static const signUp = RouteNames.signUp;
  static const otpVerification = RouteNames.otpVerification;
  static const forgotPassword = RouteNames.forgotPassword;
  static const securityVerification = RouteNames.securityVerification;
  static const mainShell = RouteNames.mainShell;
  static const home = RouteNames.home;
  static const explore = RouteNames.explore;
  static const searchResults = RouteNames.searchResults;
  static const productDetails = RouteNames.productDetails;
  static const imageGallery = RouteNames.imageGallery;
  static const productReviews = RouteNames.productReviews;
  static const sellerProfile = RouteNames.sellerProfile;
  static const orders = RouteNames.orders;
  static const orderDetails = RouteNames.orderDetails;
  static const invoice = RouteNames.invoice;
  static const trackOrder = RouteNames.trackOrder;
  static const deliveryTimeline = RouteNames.deliveryTimeline;
  static const messages = RouteNames.messages;
  static const conversation = RouteNames.conversation;
  static const offerNegotiation = RouteNames.offerNegotiation;
  static const profile = RouteNames.profile;
  static const myListings = RouteNames.myListings;
  static const saved = RouteNames.saved;
  static const notifications = RouteNames.notifications;
  static const createListing = RouteNames.createListing;
  static const uploadImages = RouteNames.uploadImages;
  static const listingPreview = RouteNames.listingPreview;
  static const settings = RouteNames.settings;
  static const editProfile = RouteNames.editProfile;
  static const changePassword = RouteNames.changePassword;
  static const savedAddresses = RouteNames.savedAddresses;
  static const paymentMethods = RouteNames.paymentMethods;
  static const privacySecurity = RouteNames.privacySecurity;
  static const helpCenter = RouteNames.helpCenter;
  static const about = RouteNames.about;

    static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const Error404Screen(),
    redirect: RouteGuards.handleAuthRedirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.signUp,
        name: 'signUp',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.otpVerification,
        name: 'otpVerification',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: OtpVerificationScreen(
            email: state.uri.queryParameters['email'],
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.securityVerification,
        name: 'securityVerification',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SecurityVerificationScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.searchResults,
        name: 'searchResults',
        pageBuilder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return _buildPage(
            state: state,
            child: SearchResultsScreen(query: query),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => _MainShellWrapper(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  state: state,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.explore,
                name: 'explore',
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  state: state,
                  child: const ExploreScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.orders,
                name: 'orders',
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  state: state,
                  child: const OrdersScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.messages,
                name: 'messages',
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  state: state,
                  child: const MessagesScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.productDetails,
        name: 'productDetails',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: ProductDetailsScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.imageGallery,
        name: 'imageGallery',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: ImageGalleryScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.productReviews,
        name: 'productReviews',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: ProductReviewsScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.sellerProfile,
        name: 'sellerProfile',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: SellerProfileScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.orderDetails,
        name: 'orderDetails',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: OrderDetailsScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.invoice,
        name: 'invoice',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: InvoiceScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.trackOrder,
        name: 'trackOrder',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: TrackOrderScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.deliveryTimeline,
        name: 'deliveryTimeline',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: DeliveryTimelineScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.conversation,
        name: 'conversation',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: ConversationScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.offerNegotiation,
        name: 'offerNegotiation',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: OfferNegotiationScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.myListings,
        name: 'myListings',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const MyListingsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.saved,
        name: 'saved',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SavedScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.createListing,
        name: 'createListing',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const CreateListingScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.uploadImages,
        name: 'uploadImages',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const UploadImagesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.listingPreview,
        name: 'listingPreview',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(
            state: state,
            child: ListingPreviewScreen(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: 'changePassword',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.savedAddresses,
        name: 'savedAddresses',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const SavedAddressesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.paymentMethods,
        name: 'paymentMethods',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const PaymentMethodsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.privacySecurity,
        name: 'privacySecurity',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const PrivacySecurityScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.helpCenter,
        name: 'helpCenter',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const HelpCenterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.about,
        name: 'about',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const AboutScreen(),
        ),
      ),
    ],
  );



  static CustomTransitionPage<void> _buildPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<void> _buildNoTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class _MainShellWrapper extends ConsumerWidget {
  const _MainShellWrapper({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _MainShell(
      navigationShell: navigationShell,
    );
  }
}

class _MainShell extends ConsumerStatefulWidget {
  const _MainShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<_MainShell> {
  int get _currentIndex => widget.navigationShell.currentIndex;

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                _buildNavItem(1, Icons.explore_outlined, Icons.explore, 'Explore'),
                _buildNavItem(2, Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
                _buildNavItem(3, Icons.chat_bubble_outlined, Icons.chat_bubble, 'Messages'),
                _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? filledIcon : outlinedIcon,
              color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
