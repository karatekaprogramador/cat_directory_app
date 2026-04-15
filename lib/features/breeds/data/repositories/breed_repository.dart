import 'package:dio/dio.dart';

import '../../../../core/network/network_exception.dart';
import '../../domain/entities/paginated_breeds.dart';
import '../services/cat_api_service.dart';

class BreedRepository {
  BreedRepository(this._apiService);

  final CatApiService _apiService;

  Future<PaginatedBreeds> getBreedsPage({required int page}) async {
    try {
      return await _apiService.getBreeds(page: page);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (_) {
      throw const NetworkException('No fue posible obtener las razas.');
    }
  }
}
