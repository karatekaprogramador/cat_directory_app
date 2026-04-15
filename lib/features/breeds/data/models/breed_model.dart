import '../../domain/entities/breed.dart';

class BreedModel {
  BreedModel._();

  static Breed fromJson(Map<String, dynamic> json) {
    return Breed(
      breed: (json['breed'] as String?)?.trim() ?? 'N/A',
      country: (json['country'] as String?)?.trim() ?? 'N/A',
      origin: (json['origin'] as String?)?.trim() ?? 'N/A',
      coat: (json['coat'] as String?)?.trim() ?? 'N/A',
      pattern: (json['pattern'] as String?)?.trim() ?? 'N/A',
    );
  }
}
