import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/sign_up_screen.dart';
import '../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/security/presentation/pages/security_verification_screen.dart';
import '../../features/home/presentation/widgets/main_shell.dart';
import '../../features/home/presentation/pages/empty_wishlist_screen.dart';
import '../../features/home/presentation/pages/error_404_screen.dart';
import '../../features/home/presentation/pages/no_internet_screen.dart';
import '../../features/home/presentation/pages/loading_skeleton_screen.dart';
import '../../features/home/presentation/pages/search_results_screen.dart';
import '../../features/home/presentation/pages/product_details_screen.dart';
import '../../features/home/presentation/pages/image_gallery_screen.dart';
import '../../features/home/presentation/pages/product_reviews_screen.dart';
import '../../features/home/presentation/pages/seller_profile_screen.dart';
import '../../features/home/presentation/pages/order_details_screen.dart';
import '../../features/home/presentation/pages/invoice_screen.dart';
import '../../features/home/presentation/pages/track_order_screen.dart';
import '../../features/home/presentation/pages/delivery_timeline_screen.dart';
import '../../features/home/presentation/pages/create_listing_screen.dart';
import '../../features/home/presentation/pages/upload_images_screen.dart';
import '../../features/home/presentation/pages/listing_preview_screen.dart';
import '../../features/home/presentation/pages/my_listings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String securityVerification = '/security-verification';
  static const String mainShell = '/main-shell';
  static const String emptyWishlist = '/empty-wishlist';
  static const String error404 = '/error-404';
  static const String noInternet = '/no-internet';
  static const String loadingSkeleton = '/loading-skeleton';
  static const String searchResults = '/search-results';
  static const String productDetails = '/product-details';
  static const String imageGallery = '/image-gallery';
  static const String productReviews = '/product-reviews';
  static const String sellerProfile = '/seller-profile';
  static const String orderDetails = '/order-details';
  static const String invoice = '/invoice';
  static const String trackOrder = '/track-order';
  static const String deliveryTimeline = '/delivery-timeline';
  static const String createListing = '/create-listing';
  static const String uploadImages = '/upload-images';
  static const String listingPreview = '/listing-preview';
  static const String myListings = '/my-listings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case otpVerification:
        return MaterialPageRoute(
          builder: (_) => const OtpVerificationScreen(),
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case securityVerification:
        return MaterialPageRoute(
          builder: (_) => const SecurityVerificationScreen(),
        );
      case mainShell:
        return MaterialPageRoute(
          builder: (_) => const MainShell(),
        );
      case emptyWishlist:
        return MaterialPageRoute(
          builder: (_) => const EmptyWishlistScreen(),
        );
      case error404:
        return MaterialPageRoute(
          builder: (_) => const Error404Screen(),
        );
      case noInternet:
        return MaterialPageRoute(
          builder: (_) => const NoInternetScreen(),
        );
      case loadingSkeleton:
        return MaterialPageRoute(
          builder: (_) => const LoadingSkeletonScreen(),
        );
      case searchResults:
        return MaterialPageRoute(
          builder: (_) => const SearchResultsScreen(),
        );
      case productDetails:
        return MaterialPageRoute(
          builder: (_) => const ProductDetailsScreen(),
        );
      case imageGallery:
        return MaterialPageRoute(
          builder: (_) => const ImageGalleryScreen(),
        );
      case productReviews:
        return MaterialPageRoute(
          builder: (_) => const ProductReviewsScreen(),
        );
      case sellerProfile:
        return MaterialPageRoute(
          builder: (_) => const SellerProfileScreen(),
        );
      case orderDetails:
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
        );
      case invoice:
        return MaterialPageRoute(
          builder: (_) => const InvoiceScreen(),
        );
      case trackOrder:
        return MaterialPageRoute(
          builder: (_) => const TrackOrderScreen(),
        );
      case deliveryTimeline:
        return MaterialPageRoute(
          builder: (_) => const DeliveryTimelineScreen(),
        );
      case createListing:
        return MaterialPageRoute(
          builder: (_) => const CreateListingScreen(),
        );
      case uploadImages:
        return MaterialPageRoute(
          builder: (_) => const UploadImagesScreen(),
        );
      case listingPreview:
        return MaterialPageRoute(
          builder: (_) => const ListingPreviewScreen(),
        );
      case myListings:
        return MaterialPageRoute(
          builder: (_) => const MyListingsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
