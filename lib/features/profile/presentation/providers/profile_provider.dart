import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/listing_model.dart';
import '../../../home/data/repositories/listing_repository.dart';
import '../../../home/presentation/providers/listing_provider.dart';
import '../../data/models/review_model.dart';
import '../../data/models/seller_model.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_remote.dart';

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
  final ListingRepository _listingRepository;

  ProfileNotifier(this._repository, this._listingRepository)
      : super(const ProfileState());

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

  Future<void> getMyListings({String? status}) async {
    state = state.copyWith(myListings: const AsyncValue.loading());
    final result = await _repository.getMyListings(status: status);
    if (result.isSuccess) {
      state = state.copyWith(myListings: AsyncValue.data(result.data ?? []));
    } else {
      state = state.copyWith(
        myListings: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> getWishlist() async {
    state = state.copyWith(wishlist: const AsyncValue.loading());
    final result = await _repository.getWishlist();
    if (result.isSuccess) {
      state = state.copyWith(wishlist: AsyncValue.data(result.data ?? []));
    } else {
      state = state.copyWith(
        wishlist: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> removeFromWishlist(String listingId) async {
    final result = await _repository.removeFromWishlist(listingId: listingId);
    if (result.isSuccess) {
      final current = state.wishlist.valueOrNull ?? [];
      state = state.copyWith(
        wishlist: AsyncValue.data(
          current.where((l) => l.id != listingId).toList(),
        ),
      );
    }
  }

  Future<void> archiveListing(String listingId) async {
    final result = await _listingRepository.updateListing(
      id: listingId,
      data: {'status': ListingStatus.expired.value},
    );
    if (!result.isSuccess) return;

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

  Future<void> markAsSold(String listingId) async {
    final result = await _listingRepository.updateListing(
      id: listingId,
      data: {'status': ListingStatus.sold.value},
    );
    if (!result.isSuccess) return;

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

  Future<void> deleteListing(String listingId) async {
    final result = await _listingRepository.deleteListing(id: listingId);
    if (!result.isSuccess) return;

    final current = state.myListings.valueOrNull ?? [];
    state = state.copyWith(
      myListings: AsyncValue.data(
        current.where((l) => l.id != listingId).toList(),
      ),
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  if (ApiConfig.useRemoteBackend) {
    return ProfileRemoteRepository();
  }
  return MockProfileRepository();
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    final listingRepository = ref.watch(listingRepositoryProvider);
    return ProfileNotifier(repository, listingRepository);
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
