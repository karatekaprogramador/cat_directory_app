import 'package:dio/dio.dart';

import '../../../../core/network/network_exception.dart';
import '../../../breeds/data/services/cat_api_service.dart';

class CatFactRepository {
  CatFactRepository(this._apiService);

  final CatApiService _apiService;

  Future<String> getRandomFact() async {
    try {
      return await _apiService.getRandomFact();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (_) {
      throw const NetworkException('No fue posible cargar el dato curioso.');
    }
  }
}
