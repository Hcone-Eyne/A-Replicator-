import '../models/category_model.dart';
import '../models/listing_model.dart';
import '../../../../shared/models/pagination.dart';
import '../../../../shared/models/result.dart';

abstract class ListingRepository {
  Future<Result<Pagination<ListingModel>>> getListings({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
  });

  Future<Result<ListingModel>> getListingById({
    required String id,
  });

  Future<Result<Pagination<ListingModel>>> searchListings({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Result<List<CategoryModel>>> getCategories();

  Future<Result<ListingModel>> createListing({
    required Map<String, dynamic> data,
  });

  Future<Result<ListingModel>> updateListing({
    required String id,
    required Map<String, dynamic> data,
  });

  Future<Result<void>> deleteListing({
    required String id,
  });

  Future<Result<void>> toggleFavorite({
    required String listingId,
  });
}

class MockListingRepository implements ListingRepository {
  static final _mockListings = <String, ListingModel>{
    'list_001': ListingModel(
      id: 'list_001',
      title: 'iPhone 15 Pro Max 256GB',
      description: 'Como nuevo, con caja y accesorios originales. Bateria al 98%.',
      price: 18500.0,
      images: const [],
      category: 'Electronics',
      location: 'Ciudad de Mexico',
      sellerId: 'user_002',
      status: ListingStatus.active,
      viewCount: 234,
      favoriteCount: 18,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    'list_002': ListingModel(
      id: 'list_002',
      title: 'Nike Air Max 90 Talla 10',
      description: 'Zapatos deportivos en excelente estado, usados solo dos veces.',
      price: 1800.0,
      images: const [],
      category: 'Fashion',
      location: 'Guadalajara',
      sellerId: 'user_003',
      status: ListingStatus.active,
      viewCount: 89,
      favoriteCount: 7,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    'list_003': ListingModel(
      id: 'list_003',
      title: 'MacBook Air M2 13"',
      description: '16GB RAM, 512GB SSD. Perfecto estado, con cargador original.',
      price: 21000.0,
      images: const [],
      category: 'Electronics',
      location: 'Monterrey',
      sellerId: 'user_004',
      status: ListingStatus.active,
      viewCount: 412,
      favoriteCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    'list_004': ListingModel(
      id: 'list_004',
      title: 'Sofa 3 Plazas Color Gris',
      description: 'Sofa moderno en tela premium, muy cómodo y sin manchas.',
      price: 5500.0,
      images: const [],
      category: 'Home',
      location: 'Puebla',
      sellerId: 'user_005',
      status: ListingStatus.active,
      viewCount: 67,
      favoriteCount: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    'list_005': ListingModel(
      id: 'list_005',
      title: 'Bicicleta de Montaña Trek',
      description: '21 velocidades, suspension delantera. Ideal para senderismo.',
      price: 4200.0,
      images: const [],
      category: 'Sports',
      location: 'Queretaro',
      sellerId: 'user_006',
      status: ListingStatus.active,
      viewCount: 156,
      favoriteCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    'list_010': ListingModel(
      id: 'list_010',
      title: 'PlayStation 5 + 2 Mandos',
      description: 'Consola en perfecto estado con dos mandos DualSense.',
      price: 8500.0,
      images: const [],
      category: 'Electronics',
      location: 'Ciudad de Mexico',
      sellerId: 'user_001',
      status: ListingStatus.active,
      viewCount: 189,
      favoriteCount: 14,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  };

  static final _mockCategories = [
    const CategoryModel(id: 'cat_01', name: 'Electronics', icon: 'phone', count: 124),
    const CategoryModel(id: 'cat_02', name: 'Fashion', icon: 'fashion', count: 89),
    const CategoryModel(id: 'cat_03', name: 'Home', icon: 'home', count: 56),
    const CategoryModel(id: 'cat_04', name: 'Sports', icon: 'sports', count: 34),
    const CategoryModel(id: 'cat_05', name: 'Vehicles', icon: 'car', count: 21),
    const CategoryModel(id: 'cat_06', name: 'Toys', icon: 'toys', count: 18),
  ];

  List<ListingModel> _getFilteredList({
    String? category,
    String? query,
  }) {
    return _mockListings.values.where((l) {
      final matchCategory = category == null || category.isEmpty || l.category == category;
      final matchQuery = query == null ||
          query.isEmpty ||
          l.title.toLowerCase().contains(query.toLowerCase()) ||
          l.description.toLowerCase().contains(query.toLowerCase());
      return matchCategory && matchQuery && l.status == ListingStatus.active;
    }).toList();
  }

  static ListingModel? getById(String id) => _mockListings[id];

  @override
  Future<Result<Pagination<ListingModel>>> getListings({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final items = _getFilteredList(category: category);

    if (sortBy == 'price_asc') {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'price_desc') {
      items.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'newest') {
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final totalItems = items.length;
    final totalPages = (totalItems / limit).ceil().clamp(1, 999);
    final start = (page - 1) * limit;
    final end = start + limit;
    final pagedItems = items.sublist(start, end.clamp(0, totalItems));

    return Success(Pagination<ListingModel>(
      items: pagedItems,
      page: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasMore: page < totalPages,
    ));
  }

  @override
  Future<Result<ListingModel>> getListingById({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final listing = _mockListings[id];
    if (listing == null) {
      return const Error('Listing not found');
    }
    return Success(listing);
  }

  @override
  Future<Result<Pagination<ListingModel>>> searchListings({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final items = _getFilteredList(query: query);
    final totalItems = items.length;
    final totalPages = (totalItems / limit).ceil().clamp(1, 999);
    final start = (page - 1) * limit;
    final end = start + limit;
    final pagedItems = items.sublist(start, end.clamp(0, totalItems));

    return Success(Pagination<ListingModel>(
      items: pagedItems,
      page: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasMore: page < totalPages,
    ));
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Success(_mockCategories);
  }

  @override
  Future<Result<ListingModel>> createListing({
    required Map<String, dynamic> data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newListing = ListingModel(
      id: 'list_${DateTime.now().millisecondsSinceEpoch}',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      category: data['category'] as String? ?? '',
      location: data['location'] as String? ?? '',
      sellerId: data['sellerId'] as String? ?? 'user_001',
      status: ListingStatus.active,
      createdAt: DateTime.now(),
    );
    _mockListings[newListing.id] = newListing;
    return Success(newListing);
  }

  @override
  Future<Result<ListingModel>> updateListing({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final existing = _mockListings[id];
    if (existing == null) {
      return const Error('Listing not found');
    }

    final updated = existing.copyWith(
      title: data['title'] as String? ?? existing.title,
      description: data['description'] as String? ?? existing.description,
      price: (data['price'] as num?)?.toDouble() ?? existing.price,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? existing.images,
      category: data['category'] as String? ?? existing.category,
      location: data['location'] as String? ?? existing.location,
      status: data['status'] is String
          ? ListingStatus.fromString(data['status'] as String)
          : existing.status,
    );
    _mockListings[id] = updated;
    return Success(updated);
  }

  @override
  Future<Result<void>> deleteListing({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (!_mockListings.containsKey(id)) {
      return const Error('Listing not found');
    }
    _mockListings.remove(id);
    return const Success(null);
  }

  @override
  Future<Result<void>> toggleFavorite({required String listingId}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final listing = _mockListings[listingId];
    if (listing == null) {
      return const Error('Listing not found');
    }

    final isFavorited = listing.favoriteCount > 0;
    _mockListings[listingId] = listing.copyWith(
      favoriteCount: isFavorited ? listing.favoriteCount - 1 : listing.favoriteCount + 1,
    );
    return const Success(null);
  }
}
