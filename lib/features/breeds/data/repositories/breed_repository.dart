import 'package:dio/dio.dart';

import '../../../../core/network/network_exception.dart';
import '../../domain/entities/paginated_breeds.dart';
import '../services/breeds_cache_service.dart';
import '../services/cat_api_service.dart';

class BreedRepository {
  BreedRepository(this._apiService, this._cacheService);

  final CatApiService _apiService;
  final BreedsCacheService _cacheService;

  PaginatedBreeds? getCachedFirstPage() => _cacheService.readFirstPage();

  Future<PaginatedBreeds> getBreedsPage({required int page}) async {
    try {
      final result = await _apiService.getBreeds(page: page);
      if (page == 1) {
        await _cacheService.saveFirstPage(result);
      }
      return result;
    } on DioException catch (e) {
      if (page == 1) {
        final cached = _cacheService.readFirstPage();
        if (cached != null) {
          return cached;
        }
      }
      throw NetworkException.fromDioException(e);
    } catch (_) {
      if (page == 1) {
        final cached = _cacheService.readFirstPage();
        if (cached != null) {
          return cached;
        }
      }
      throw const NetworkException('No fue posible obtener las razas.');
    }
  }
}
