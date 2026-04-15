import 'package:dio/dio.dart';

import '../models/paginated_breeds_response.dart';

class CatApiService {
  CatApiService(this._dio);

  final Dio _dio;

  Future<PaginatedBreedsResponse> getBreeds({
    required int page,
    int limit = 10,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/breeds',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return PaginatedBreedsResponse.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<String> getRandomFact() async {
    final response = await _dio.get<Map<String, dynamic>>('/fact');

    return (response.data?['fact'] as String?)?.trim() ??
        'No fue posible obtener un dato curioso por ahora.';
  }
}
