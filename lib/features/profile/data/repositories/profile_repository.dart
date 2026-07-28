import '../../../auth/data/models/user_model.dart';
import '../models/review_model.dart';
import '../models/seller_model.dart';
import '../../../../shared/models/result.dart';

abstract class ProfileRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<UserModel>> updateProfile({
    required Map<String, dynamic> data,
  });

  Future<Result<SellerModel>> getSellerProfile({
    required String sellerId,
  });

  Future<Result<void>> followSeller({
    required String sellerId,
  });

  Future<Result<void>> unfollowSeller({
    required String sellerId,
  });

  Future<Result<List<ReviewModel>>> getReviews({
    required String sellerId,
    int page = 1,
    int limit = 20,
  });
}

class MockProfileRepository implements ProfileRepository {
  static var _mockProfile = const UserModel(
    id: 'user_001',
    name: 'Carlos Mendoza',
    email: 'carlos@example.com',
    phone: '+52 55 1234 5678',
    avatarUrl: '',
    location: 'Ciudad de Mexico, Mexico',
    isVerified: true,
    listingsCount: 12,
    salesCount: 48,
    followers: ['user_002', 'user_003', 'user_004'],
    following: ['user_005', 'user_006'],
    listingIds: ['list_010', 'list_011'],
    wishlistIds: ['list_020'],
  );

  static final _mockSellers = <String, SellerModel>{
    'user_002': const SellerModel(
      id: 'user_002',
      name: 'Maria Lopez',
      avatarUrl: '',
      isVerified: true,
      rating: 4.8,
      salesCount: 95,
      positivePercent: 98.5,
      memberDuration: '2 years',
      bio: 'Vendedor profesional de electrónicos. Envío a todo el país.',
      listingsCount: 24,
    ),
    'user_003': const SellerModel(
      id: 'user_003',
      name: 'Juan Perez',
      avatarUrl: '',
      isVerified: false,
      rating: 4.2,
      salesCount: 32,
      positivePercent: 92.0,
      memberDuration: '1 year',
      bio: 'Ropa y calzado deportivo de marca.',
      listingsCount: 15,
    ),
    'user_004': const SellerModel(
      id: 'user_004',
      name: 'Ana Garcia',
      avatarUrl: '',
      isVerified: true,
      rating: 4.9,
      salesCount: 128,
      positivePercent: 99.2,
      memberDuration: '3 years',
      bio: 'Apple products specialist. Certified reseller.',
      listingsCount: 32,
    ),
  };

  static final _mockReviews = <String, List<ReviewModel>>{
    'user_002': [
      ReviewModel(
        id: 'rev_001',
        sellerId: 'user_002',
        userName: 'Carlos Mendoza',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 5)),
        text: 'Excelente vendedor! El producto llego en perfecto estado y muy rapido.',
      ),
      ReviewModel(
        id: 'rev_002',
        sellerId: 'user_002',
        userName: 'Laura Sanchez',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 15)),
        text: 'Muy profesional. Recomendado 100%.',
        hasPhoto: true,
      ),
      ReviewModel(
        id: 'rev_003',
        sellerId: 'user_002',
        userName: 'Roberto Diaz',
        rating: 4,
        date: DateTime.now().subtract(const Duration(days: 30)),
        text: 'Buen producto, demoro un poco el envio pero todo bien.',
      ),
    ],
    'user_003': [
      ReviewModel(
        id: 'rev_004',
        sellerId: 'user_003',
        userName: 'Pedro Ramirez',
        rating: 4,
        date: DateTime.now().subtract(const Duration(days: 10)),
        text: 'Buena calidad, tal como se veia en las fotos.',
      ),
    ],
    'user_004': [
      ReviewModel(
        id: 'rev_005',
        sellerId: 'user_004',
        userName: 'Sofia Torres',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 3)),
        text: 'MacBook en perfecto estado. Envio super rapido.',
      ),
      ReviewModel(
        id: 'rev_006',
        sellerId: 'user_004',
        userName: 'Miguel Angel',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 8)),
        text: 'Excelente vendedor, muy confiable.',
      ),
    ],
  };

  @override
  Future<Result<UserModel>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Success(_mockProfile);
  }

  @override
  Future<Result<UserModel>> updateProfile({required Map<String, dynamic> data}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _mockProfile = _mockProfile.copyWith(
      name: data['name'] as String? ?? _mockProfile.name,
      phone: data['phone'] as String? ?? _mockProfile.phone,
      location: data['location'] as String? ?? _mockProfile.location,
      avatarUrl: data['avatarUrl'] as String? ?? _mockProfile.avatarUrl,
    );
    return Success(_mockProfile);
  }

  @override
  Future<Result<SellerModel>> getSellerProfile({required String sellerId}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final seller = _mockSellers[sellerId];
    if (seller == null) return const Error('Seller not found');
    return Success(seller);
  }

  @override
  Future<Result<void>> followSeller({required String sellerId}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_mockSellers.containsKey(sellerId)) {
      return const Error('Seller not found');
    }
    _mockProfile = _mockProfile.copyWith(
      following: [..._mockProfile.following, sellerId],
    );
    return const Success(null);
  }

  @override
  Future<Result<void>> unfollowSeller({required String sellerId}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _mockProfile = _mockProfile.copyWith(
      following: _mockProfile.following.where((id) => id != sellerId).toList(),
    );
    return const Success(null);
  }

  @override
  Future<Result<List<ReviewModel>>> getReviews({
    required String sellerId,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final reviews = _mockReviews[sellerId] ?? [];
    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = reviews.sublist(start, end.clamp(0, reviews.length));
    return Success(paged);
  }
}
