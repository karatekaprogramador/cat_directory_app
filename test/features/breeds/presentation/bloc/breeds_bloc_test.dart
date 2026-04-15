import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cat_directory_app/features/breeds/data/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/paginated_breeds.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:cat_directory_app/features/breeds/presentation/cubit/breeds_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBreedRepository extends Mock implements BreedRepository {}

void main() {
  late BreedRepository repository;

  const bengal = Breed(
    breed: 'Bengal',
    country: 'United States',
    origin: 'Hybrid',
    coat: 'Short',
    pattern: 'Spotted',
  );

  const persian = Breed(
    breed: 'Persian',
    country: 'Iran',
    origin: 'Natural',
    coat: 'Long',
    pattern: 'Solid',
  );

  setUp(() {
    repository = _MockBreedRepository();
  });

  group('BreedsBloc', () {
    blocTest<BreedsBloc, BreedsState>(
      'emite loading y luego success al iniciar',
      build: () {
        when(
          () => repository.getBreedsPage(page: 1),
        ).thenAnswer(
          (_) async => const PaginatedBreeds(
            items: [bengal, persian],
            currentPage: 1,
            lastPage: 2,
          ),
        );
        return BreedsBloc(repository);
      },
      act: (bloc) => bloc.add(const BreedsStarted()),
      expect: () => <BreedsState>[
        const BreedsState(status: BreedsStatus.loading),
        const BreedsState(
          status: BreedsStatus.success,
          breeds: [bengal, persian],
          visibleBreeds: [bengal, persian],
          currentPage: 1,
          hasMore: true,
        ),
      ],
      verify: (_) {
        verify(() => repository.getBreedsPage(page: 1)).called(1);
      },
    );

    blocTest<BreedsBloc, BreedsState>(
      'aplica debounce y solo conserva la ultima busqueda',
      build: () {
        when(
          () => repository.getBreedsPage(page: 1),
        ).thenAnswer(
          (_) async => const PaginatedBreeds(
            items: [bengal, persian],
            currentPage: 1,
            lastPage: 1,
          ),
        );
        return BreedsBloc(repository);
      },
      act: (bloc) async {
        bloc.add(const BreedsStarted());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(const BreedsSearchChanged('be'));
        bloc.add(const BreedsSearchChanged('pers'));
      },
      wait: const Duration(milliseconds: 450),
      expect: () => <BreedsState>[
        const BreedsState(status: BreedsStatus.loading),
        const BreedsState(
          status: BreedsStatus.success,
          breeds: [bengal, persian],
          visibleBreeds: [bengal, persian],
          currentPage: 1,
          hasMore: false,
        ),
        const BreedsState(
          status: BreedsStatus.success,
          breeds: [bengal, persian],
          visibleBreeds: [persian],
          query: 'pers',
          currentPage: 1,
          hasMore: false,
        ),
      ],
    );

    blocTest<BreedsBloc, BreedsState>(
      'usa droppable para ignorar peticiones de loadMore en paralelo',
      build: () {
        when(
          () => repository.getBreedsPage(page: 1),
        ).thenAnswer(
          (_) async => const PaginatedBreeds(
            items: [bengal],
            currentPage: 1,
            lastPage: 3,
          ),
        );

        final page2Completer = Completer<PaginatedBreeds>();
        when(() => repository.getBreedsPage(page: 2)).thenAnswer(
          (_) => page2Completer.future,
        );

        Future<void>.delayed(const Duration(milliseconds: 120), () {
          page2Completer.complete(
            const PaginatedBreeds(
              items: [persian],
              currentPage: 2,
              lastPage: 3,
            ),
          );
        });

        return BreedsBloc(repository);
      },
      act: (bloc) async {
        bloc.add(const BreedsStarted());
        await Future<void>.delayed(const Duration(milliseconds: 30));
        bloc.add(const BreedsLoadMoreRequested());
        bloc.add(const BreedsLoadMoreRequested());
      },
      wait: const Duration(milliseconds: 300),
      verify: (_) {
        verify(() => repository.getBreedsPage(page: 2)).called(1);
      },
    );
  });
}
