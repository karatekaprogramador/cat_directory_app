import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repositories/breed_repository.dart';
import '../../domain/entities/breed.dart';
import '../cubit/breeds_state.dart';
import 'breeds_event.dart';

EventTransformer<T> _debounceTransformer<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  BreedsBloc(this._repository) : super(const BreedsState()) {
    on<BreedsStarted>(_onStarted);
    on<BreedsRefreshed>(_onRefreshed);
    on<BreedsLoadMoreRequested>(_onLoadMoreRequested, transformer: droppable());
    on<BreedsSearchChanged>(
      _onSearchChanged,
      transformer: _debounceTransformer(const Duration(milliseconds: 350)),
    );
  }

  final BreedRepository _repository;

  Future<void> _onStarted(BreedsStarted event, Emitter<BreedsState> emit) async {
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

  Future<void> _onRefreshed(
    BreedsRefreshed event,
    Emitter<BreedsState> emit,
  ) async {
    add(const BreedsStarted());
  }

  Future<void> _onLoadMoreRequested(
    BreedsLoadMoreRequested event,
    Emitter<BreedsState> emit,
  ) async {
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

  void _onSearchChanged(BreedsSearchChanged event, Emitter<BreedsState> emit) {
    final normalized = event.query.trim().toLowerCase();
    emit(
      state.copyWith(
        query: normalized,
        visibleBreeds: _applyQuery(state.breeds, normalized),
      ),
    );
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
}
