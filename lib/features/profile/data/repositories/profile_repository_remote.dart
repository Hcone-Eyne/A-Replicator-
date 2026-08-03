import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/result.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/seller_model.dart';
import '../repositories/profile_repository.dart';

class ProfileRemoteRepository extends ApiRepository implements ProfileRepository {
  @override
  Future<Result<UserModel>> getProfile() {
    return guard(() async {
      final response = await ApiClient.dio.get('/profile');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<UserModel>> updateProfile({
    required Map<String, dynamic> data,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.put('/profile', data: data);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<SellerModel>> getSellerProfile({required String sellerId}) {
    return guard(() async {
      final response = await ApiClient.dio.get('/sellers/$sellerId');
      return SellerModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<void>> followSeller({required String sellerId}) {
    return guardVoid(() => ApiClient.dio.post('/sellers/$sellerId/follow'));
  }

  @override
  Future<Result<void>> unfollowSeller({required String sellerId}) {
    return guardVoid(() => ApiClient.dio.delete('/sellers/$sellerId/follow'));
  }

  @override
  Future<Result<List<ReviewModel>>> getReviews({
    required String sellerId,
    int page = 1,
    int limit = 20,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/sellers/$sellerId/reviews',
        queryParameters: {'page': page, 'limit': limit},
      );
      return (response.data as List<dynamic>)
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
