// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Breed _$BreedFromJson(Map<String, dynamic> json) {
  return _Breed.fromJson(json);
}

/// @nodoc
mixin _$Breed {
  String get breed => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get origin => throw _privateConstructorUsedError;
  String get coat => throw _privateConstructorUsedError;
  String get pattern => throw _privateConstructorUsedError;

  /// Serializes this Breed to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Breed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedCopyWith<Breed> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedCopyWith<$Res> {
  factory $BreedCopyWith(Breed value, $Res Function(Breed) then) =
      _$BreedCopyWithImpl<$Res, Breed>;
  @useResult
  $Res call({
    String breed,
    String country,
    String origin,
    String coat,
    String pattern,
  });
}

/// @nodoc
class _$BreedCopyWithImpl<$Res, $Val extends Breed>
    implements $BreedCopyWith<$Res> {
  _$BreedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Breed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breed = null,
    Object? country = null,
    Object? origin = null,
    Object? coat = null,
    Object? pattern = null,
  }) {
    return _then(
      _value.copyWith(
            breed: null == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as String,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
            origin: null == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as String,
            coat: null == coat
                ? _value.coat
                : coat // ignore: cast_nullable_to_non_nullable
                      as String,
            pattern: null == pattern
                ? _value.pattern
                : pattern // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedImplCopyWith<$Res> implements $BreedCopyWith<$Res> {
  factory _$$BreedImplCopyWith(
    _$BreedImpl value,
    $Res Function(_$BreedImpl) then,
  ) = __$$BreedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String breed,
    String country,
    String origin,
    String coat,
    String pattern,
  });
}

/// @nodoc
class __$$BreedImplCopyWithImpl<$Res>
    extends _$BreedCopyWithImpl<$Res, _$BreedImpl>
    implements _$$BreedImplCopyWith<$Res> {
  __$$BreedImplCopyWithImpl(
    _$BreedImpl _value,
    $Res Function(_$BreedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Breed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breed = null,
    Object? country = null,
    Object? origin = null,
    Object? coat = null,
    Object? pattern = null,
  }) {
    return _then(
      _$BreedImpl(
        breed: null == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as String,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
        origin: null == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as String,
        coat: null == coat
            ? _value.coat
            : coat // ignore: cast_nullable_to_non_nullable
                  as String,
        pattern: null == pattern
            ? _value.pattern
            : pattern // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedImpl implements _Breed {
  const _$BreedImpl({
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  factory _$BreedImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedImplFromJson(json);

  @override
  final String breed;
  @override
  final String country;
  @override
  final String origin;
  @override
  final String coat;
  @override
  final String pattern;

  @override
  String toString() {
    return 'Breed(breed: $breed, country: $country, origin: $origin, coat: $coat, pattern: $pattern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedImpl &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.coat, coat) || other.coat == coat) &&
            (identical(other.pattern, pattern) || other.pattern == pattern));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, breed, country, origin, coat, pattern);

  /// Create a copy of Breed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedImplCopyWith<_$BreedImpl> get copyWith =>
      __$$BreedImplCopyWithImpl<_$BreedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedImplToJson(this);
  }
}

abstract class _Breed implements Breed {
  const factory _Breed({
    required final String breed,
    required final String country,
    required final String origin,
    required final String coat,
    required final String pattern,
  }) = _$BreedImpl;

  factory _Breed.fromJson(Map<String, dynamic> json) = _$BreedImpl.fromJson;

  @override
  String get breed;
  @override
  String get country;
  @override
  String get origin;
  @override
  String get coat;
  @override
  String get pattern;

  /// Create a copy of Breed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedImplCopyWith<_$BreedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
