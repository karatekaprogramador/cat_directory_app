import 'package:equatable/equatable.dart';

enum FactStatus { initial, loading, success, failure }

class BreedDetailState extends Equatable {
  const BreedDetailState({
    this.factStatus = FactStatus.initial,
    this.fact = '',
    this.factError,
  });

  final FactStatus factStatus;
  final String fact;
  final String? factError;

  BreedDetailState copyWith({
    FactStatus? factStatus,
    String? fact,
    String? factError,
    bool clearError = false,
  }) {
    return BreedDetailState(
      factStatus: factStatus ?? this.factStatus,
      fact: fact ?? this.fact,
      factError: clearError ? null : (factError ?? this.factError),
    );
  }

  @override
  List<Object?> get props => [factStatus, fact, factError];
}
