import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/listing_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/seller_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileState {
  final AsyncValue<UserModel?> userProfile;
  final AsyncValue<List<ListingModel>> myListings;
  final AsyncValue<List<ListingModel>> wishlist;

  const ProfileState({
    this.userProfile = const AsyncValue.data(null),
    this.myListings = const AsyncValue.data([]),
    this.wishlist = const AsyncValue.data([]),
  });

  ProfileState copyWith({
    AsyncValue<UserModel?>? userProfile,
    AsyncValue<List<ListingModel>>? myListings,
    AsyncValue<List<ListingModel>>? wishlist,
  }) {
    return ProfileState(
      userProfile: userProfile ?? this.userProfile,
      myListings: myListings ?? this.myListings,
      wishlist: wishlist ?? this.wishlist,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const ProfileState());

  Future<void> getProfile() async {
    state = state.copyWith(userProfile: const AsyncValue.loading());
    final result = await _repository.getProfile();
    if (result.isSuccess) {
      state = state.copyWith(userProfile: AsyncValue.data(result.data));
    } else {
      state = state.copyWith(
        userProfile: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? location,
  }) async {
    final currentProfile = state.userProfile.valueOrNull;
    if (currentProfile == null) return;

    state = state.copyWith(userProfile: const AsyncValue.loading());
    final result = await _repository.updateProfile(
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (location != null) 'location': location,
      },
    );
    if (result.isSuccess) {
      state = state.copyWith(userProfile: AsyncValue.data(result.data));
    } else {
      state = state.copyWith(
        userProfile: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> getMyListings() async {
    state = state.copyWith(myListings: const AsyncValue.loading());
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(myListings: const AsyncValue.data([]));
  }

  Future<void> getWishlist() async {
    state = state.copyWith(wishlist: const AsyncValue.loading());
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(wishlist: const AsyncValue.data([]));
  }

  void removeFromWishlist(String listingId) {
    final current = state.wishlist.valueOrNull ?? [];
    state = state.copyWith(
      wishlist: AsyncValue.data(
        current.where((l) => l.id != listingId).toList(),
      ),
    );
  }

  void archiveListing(String listingId) {
    final current = state.myListings.valueOrNull ?? [];
    state = state.copyWith(
      myListings: AsyncValue.data(
        current.map((l) {
          if (l.id == listingId) {
            return l.copyWith(status: ListingStatus.expired);
          }
          return l;
        }).toList(),
      ),
    );
  }

  void markAsSold(String listingId) {
    final current = state.myListings.valueOrNull ?? [];
    state = state.copyWith(
      myListings: AsyncValue.data(
        current.map((l) {
          if (l.id == listingId) {
            return l.copyWith(status: ListingStatus.sold);
          }
          return l;
        }).toList(),
      ),
    );
  }

  void deleteListing(String listingId) {
    final current = state.myListings.valueOrNull ?? [];
    state = state.copyWith(
      myListings: AsyncValue.data(
        current.where((l) => l.id != listingId).toList(),
      ),
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return MockProfileRepository();
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    return ProfileNotifier(repository);
  },
);

class SellerState {
  final AsyncValue<SellerModel?> seller;
  final bool isFollowing;
  final AsyncValue<List<ReviewModel>> reviews;

  const SellerState({
    this.seller = const AsyncValue.data(null),
    this.isFollowing = false,
    this.reviews = const AsyncValue.data([]),
  });

  SellerState copyWith({
    AsyncValue<SellerModel?>? seller,
    bool? isFollowing,
    AsyncValue<List<ReviewModel>>? reviews,
  }) {
    return SellerState(
      seller: seller ?? this.seller,
      isFollowing: isFollowing ?? this.isFollowing,
      reviews: reviews ?? this.reviews,
    );
  }
}

class SellerNotifier extends StateNotifier<SellerState> {
  final ProfileRepository _repository;

  SellerNotifier(this._repository) : super(const SellerState());

  Future<void> getSellerProfile(String sellerId) async {
    state = state.copyWith(seller: const AsyncValue.loading());
    final result = await _repository.getSellerProfile(sellerId: sellerId);
    if (result.isSuccess) {
      state = state.copyWith(seller: AsyncValue.data(result.data));
    } else {
      state = state.copyWith(
        seller: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> follow(String sellerId) async {
    final result = await _repository.followSeller(sellerId: sellerId);
    if (result.isSuccess) {
      state = state.copyWith(isFollowing: true);
    }
  }

  Future<void> unfollow(String sellerId) async {
    final result = await _repository.unfollowSeller(sellerId: sellerId);
    if (result.isSuccess) {
      state = state.copyWith(isFollowing: false);
    }
  }

  Future<void> getReviews(String sellerId) async {
    state = state.copyWith(reviews: const AsyncValue.loading());
    final result = await _repository.getReviews(sellerId: sellerId);
    if (result.isSuccess) {
      state = state.copyWith(reviews: AsyncValue.data(result.data!));
    } else {
      state = state.copyWith(
        reviews: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }
}

final sellerProvider = StateNotifierProvider<SellerNotifier, SellerState>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    return SellerNotifier(repository);
  },
);
