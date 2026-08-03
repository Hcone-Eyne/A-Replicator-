import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import '../../data/models/category_model.dart';
import '../../data/models/listing_model.dart';
import '../../data/repositories/listing_repository.dart';
import '../../data/repositories/listing_repository_remote.dart';

class ListingState {
  final AsyncValue<List<ListingModel>> listings;
  final AsyncValue<List<ListingModel>> filteredListings;
  final AsyncValue<List<CategoryModel>> categories;
  final AsyncValue<ListingModel?> selectedListing;
  final String searchQuery;
  final String selectedCategory;

  const ListingState({
    this.listings = const AsyncValue.data([]),
    this.filteredListings = const AsyncValue.data([]),
    this.categories = const AsyncValue.data([]),
    this.selectedListing = const AsyncValue.data(null),
    this.searchQuery = '',
    this.selectedCategory = '',
  });

  ListingState copyWith({
    AsyncValue<List<ListingModel>>? listings,
    AsyncValue<List<ListingModel>>? filteredListings,
    AsyncValue<List<CategoryModel>>? categories,
    AsyncValue<ListingModel?>? selectedListing,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ListingState(
      listings: listings ?? this.listings,
      filteredListings: filteredListings ?? this.filteredListings,
      categories: categories ?? this.categories,
      selectedListing: selectedListing ?? this.selectedListing,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ListingNotifier extends StateNotifier<ListingState> {
  final ListingRepository _repository;

  ListingNotifier(this._repository) : super(const ListingState());

  Future<void> getListings({String? category, String? sortBy}) async {
    state = state.copyWith(listings: const AsyncValue.loading());
    final result = await _repository.getListings(category: category, sortBy: sortBy);
    if (result.isSuccess) {
      state = state.copyWith(
        listings: AsyncValue.data(result.data!.items),
        filteredListings: AsyncValue.data(result.data!.items),
      );
    } else {
      state = state.copyWith(
        listings: AsyncValue.error(result.errorMessage!, StackTrace.empty),
        filteredListings: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> getCategories() async {
    state = state.copyWith(categories: const AsyncValue.loading());
    final result = await _repository.getCategories();
    if (result.isSuccess) {
      state = state.copyWith(categories: AsyncValue.data(result.data!));
    } else {
      state = state.copyWith(
        categories: AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  Future<void> getListingById(String id) async {
    state = state.copyWith(selectedListing: const AsyncValue.loading());
    final result = await _repository.getListingById(id: id);
    if (result.isSuccess) {
      state = state.copyWith(selectedListing: AsyncValue.data(result.data));
    } else {
      state = state.copyWith(
        selectedListing:
            AsyncValue.error(result.errorMessage!, StackTrace.empty),
      );
    }
  }

  void search(String query) {
    final allListings = state.listings.valueOrNull ?? [];
    final filtered = allListings.where((listing) {
      final matchesQuery = query.isEmpty ||
          listing.title.toLowerCase().contains(query.toLowerCase()) ||
          listing.description.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = state.selectedCategory.isEmpty ||
          listing.category == state.selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
    state = state.copyWith(
      searchQuery: query,
      filteredListings: AsyncValue.data(filtered),
    );
  }

  void filterByCategory(String category) {
    final allListings = state.listings.valueOrNull ?? [];
    final filtered = allListings.where((listing) {
      final matchesCategory =
          category.isEmpty || listing.category == category;
      final matchesQuery = state.searchQuery.isEmpty ||
          listing.title
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
    state = state.copyWith(
      selectedCategory: category,
      filteredListings: AsyncValue.data(filtered),
    );
  }

  Future<void> toggleFavorite(String listingId) async {
    final result = await _repository.toggleFavorite(listingId: listingId);
    if (result.isSuccess) {
      final current = state.filteredListings.valueOrNull ?? [];
      state = state.copyWith(
        filteredListings: AsyncValue.data(
          current.map((l) {
            if (l.id == listingId) {
              final isFavorited = l.favoriteCount > 0;
              return l.copyWith(
                favoriteCount: isFavorited
                    ? l.favoriteCount - 1
                    : l.favoriteCount + 1,
              );
            }
            return l;
          }).toList(),
        ),
      );
    }
  }
}

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  if (ApiConfig.useRemoteBackend) {
    return ListingRemoteRepository();
  }
  return MockListingRepository();
});

final listingProvider = StateNotifierProvider<ListingNotifier, ListingState>(
  (ref) {
    final repository = ref.watch(listingRepositoryProvider);
    return ListingNotifier(repository);
  },
);
