import '../../domain/entities/paginated_breeds.dart';
import 'breed_model.dart';

class PaginatedBreedsResponse extends PaginatedBreeds {
  const PaginatedBreedsResponse({
    required super.items,
    required super.currentPage,
    required super.lastPage,
  });

  factory PaginatedBreedsResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(BreedModel.fromJson)
        .toList(growable: false);

    return PaginatedBreedsResponse(
      items: data,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
    );
  }
}
