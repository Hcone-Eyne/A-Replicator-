import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_repository.dart';
import '../../../../shared/models/pagination.dart';
import '../../../../shared/models/result.dart';
import '../../data/models/category_model.dart';
import '../../data/models/listing_model.dart';
import '../repositories/listing_repository.dart';

class ListingRemoteRepository extends ApiRepository implements ListingRepository {
  @override
  Future<Result<Pagination<ListingModel>>> getListings({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/listings',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (category != null && category.isNotEmpty) 'category': category,
          if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        },
      );
      return parsePagination(
        response.data as Map<String, dynamic>,
        ListingModel.fromJson,
      );
    });
  }

  @override
  Future<Result<ListingModel>> getListingById({required String id}) {
    return guard(() async {
      final response = await ApiClient.dio.get('/listings/$id');
      return ListingModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<Pagination<ListingModel>>> searchListings({
    required String query,
    int page = 1,
    int limit = 20,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.get(
        '/listings/search',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );
      return parsePagination(
        response.data as Map<String, dynamic>,
        ListingModel.fromJson,
      );
    });
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() {
    return guard(() async {
      final response = await ApiClient.dio.get('/categories');
      return (response.data as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<ListingModel>> createListing({
    required Map<String, dynamic> data,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.post('/listings', data: data);
      return ListingModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<ListingModel>> updateListing({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return guard(() async {
      final response = await ApiClient.dio.put('/listings/$id', data: data);
      return ListingModel.fromJson(response.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Result<void>> deleteListing({required String id}) {
    return guardVoid(() => ApiClient.dio.delete('/listings/$id'));
  }

  @override
  Future<Result<void>> toggleFavorite({required String listingId}) {
    return guardVoid(() => ApiClient.dio.post('/listings/$listingId/favorite'));
  }
}
