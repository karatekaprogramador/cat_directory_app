import '../../domain/entities/breed.dart';

class BreedModel extends Breed {
  const BreedModel({
    required super.breed,
    required super.country,
    required super.origin,
    required super.coat,
    required super.pattern,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      breed: (json['breed'] as String?)?.trim() ?? 'N/A',
      country: (json['country'] as String?)?.trim() ?? 'N/A',
      origin: (json['origin'] as String?)?.trim() ?? 'N/A',
      coat: (json['coat'] as String?)?.trim() ?? 'N/A',
      pattern: (json['pattern'] as String?)?.trim() ?? 'N/A',
    );
  }
}
