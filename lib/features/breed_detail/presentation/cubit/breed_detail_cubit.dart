import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/cat_fact_repository.dart';
import 'breed_detail_state.dart';

class BreedDetailCubit extends Cubit<BreedDetailState> {
  BreedDetailCubit(this._factRepository) : super(const BreedDetailState());

  final CatFactRepository _factRepository;

  Future<void> loadFact() async {
    emit(state.copyWith(factStatus: FactStatus.loading, clearError: true));

    try {
      final fact = await _factRepository.getRandomFact();
      emit(
        state.copyWith(
          factStatus: FactStatus.success,
          fact: fact,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          factStatus: FactStatus.failure,
          factError: e.toString(),
        ),
      );
    }
  }
}
