import 'package:equatable/equatable.dart';

import '../../domain/entities/breed.dart';

enum BreedsStatus { initial, loading, success, failure }

class BreedsState extends Equatable {
  const BreedsState({
    this.status = BreedsStatus.initial,
    this.breeds = const <Breed>[],
    this.visibleBreeds = const <Breed>[],
    this.errorMessage,
    this.query = '',
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  final BreedsStatus status;
  final List<Breed> breeds;
  final List<Breed> visibleBreeds;
  final String? errorMessage;
  final String query;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  BreedsState copyWith({
    BreedsStatus? status,
    List<Breed>? breeds,
    List<Breed>? visibleBreeds,
    String? errorMessage,
    String? query,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool clearError = false,
  }) {
    return BreedsState(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      visibleBreeds: visibleBreeds ?? this.visibleBreeds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        breeds,
        visibleBreeds,
        errorMessage,
        query,
        currentPage,
        hasMore,
        isLoadingMore,
      ];
}
