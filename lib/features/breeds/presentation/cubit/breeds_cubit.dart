import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/breed_repository.dart';
import '../../domain/entities/breed.dart';
import 'breeds_state.dart';

class BreedsCubit extends Cubit<BreedsState> {
  BreedsCubit(this._repository) : super(const BreedsState());

  final BreedRepository _repository;
  Timer? _debounce;

  Future<void> loadInitial() async {
    emit(
      state.copyWith(
        status: BreedsStatus.loading,
        clearError: true,
        currentPage: 0,
        hasMore: true,
      ),
    );

    try {
      final page = await _repository.getBreedsPage(page: 1);
      final filtered = _applyQuery(page.items, state.query);

      emit(
        state.copyWith(
          status: BreedsStatus.success,
          breeds: page.items,
          visibleBreeds: filtered,
          currentPage: page.currentPage,
          hasMore: page.hasMore,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BreedsStatus.failure,
          errorMessage: e.toString(),
          breeds: const <Breed>[],
          visibleBreeds: const <Breed>[],
          currentPage: 0,
          hasMore: true,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.status == BreedsStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.getBreedsPage(page: nextPage);
      final updated = <Breed>[...state.breeds, ...result.items];

      emit(
        state.copyWith(
          status: BreedsStatus.success,
          breeds: updated,
          visibleBreeds: _applyQuery(updated, state.query),
          currentPage: result.currentPage,
          hasMore: result.hasMore,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BreedsStatus.success,
          isLoadingMore: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final normalized = value.trim().toLowerCase();
      emit(
        state.copyWith(
          query: normalized,
          visibleBreeds: _applyQuery(state.breeds, normalized),
        ),
      );
    });
  }

  List<Breed> _applyQuery(List<Breed> source, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return source;
    }

    return source
        .where((item) => item.breed.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
