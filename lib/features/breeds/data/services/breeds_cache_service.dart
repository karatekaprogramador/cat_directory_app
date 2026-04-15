import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/paginated_breeds.dart';
import '../models/paginated_breeds_response.dart';

class BreedsCacheService {
  BreedsCacheService(this._preferences);

  final SharedPreferences _preferences;

  static const _firstPageKey = 'breeds_first_page_cache_v1';

  Future<void> saveFirstPage(PaginatedBreeds page) async {
    final payload = <String, dynamic>{
      'current_page': page.currentPage,
      'last_page': page.lastPage,
      'data': page.items.map((breed) => breed.toJson()).toList(growable: false),
    };

    await _preferences.setString(_firstPageKey, jsonEncode(payload));
  }

  PaginatedBreeds? readFirstPage() {
    final raw = _preferences.getString(_firstPageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        return null;
      }
      return PaginatedBreedsResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
