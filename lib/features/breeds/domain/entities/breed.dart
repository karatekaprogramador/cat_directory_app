import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

@freezed
class Breed with _$Breed {
  const factory Breed({
    required String breed,
    required String country,
    required String origin,
    required String coat,
    required String pattern,
  }) = _Breed;

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
}
