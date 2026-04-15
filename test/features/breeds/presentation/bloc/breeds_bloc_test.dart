import 'dart:async';

import 'package:cat_directory_app/features/breeds/data/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/paginated_breeds.dart';
import 'package:cat_directory_app/features/breeds/presentation/cubit/breeds_cubit.dart';
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

  group('BreedsCubit', () {
    test('emite loading y luego success al iniciar', () async {
      when(() => repository.getBreedsPage(page: 1)).thenAnswer(
        (_) async => const PaginatedBreeds(
          items: [bengal, persian],
          currentPage: 1,
          lastPage: 2,
        ),
      );

      final cubit = BreedsCubit(repository);
      final emitted = <BreedsState>[];
      final sub = cubit.stream.listen(emitted.add);

      await cubit.loadInitial();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(emitted.first.status, BreedsStatus.loading);
      expect(emitted.last.status, BreedsStatus.success);
      expect(emitted.last.breeds, const [bengal, persian]);
      expect(emitted.last.visibleBreeds, const [bengal, persian]);

      verify(() => repository.getBreedsPage(page: 1)).called(1);
      await sub.cancel();
      await cubit.close();
    });

    test('aplica debounce y solo conserva la ultima busqueda', () async {
      when(() => repository.getBreedsPage(page: 1)).thenAnswer(
        (_) async => const PaginatedBreeds(
          items: [bengal, persian],
          currentPage: 1,
          lastPage: 1,
        ),
      );

      final cubit = BreedsCubit(repository);
      final emitted = <BreedsState>[];
      final sub = cubit.stream.listen(emitted.add);

      await cubit.loadInitial();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      cubit.onSearchChanged('be');
      cubit.onSearchChanged('pers');
      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(emitted.length, 3);
      expect(emitted.last.query, 'pers');
      expect(emitted.last.visibleBreeds, const [persian]);

      await sub.cancel();
      await cubit.close();
    });

    test('ignora loadMore duplicado mientras sigue cargando', () async {
      when(() => repository.getBreedsPage(page: 1)).thenAnswer(
        (_) async =>
            const PaginatedBreeds(items: [bengal], currentPage: 1, lastPage: 3),
      );

      final page2Completer = Completer<PaginatedBreeds>();
      when(
        () => repository.getBreedsPage(page: 2),
      ).thenAnswer((_) => page2Completer.future);

      Future<void>.delayed(const Duration(milliseconds: 120), () {
        page2Completer.complete(
          const PaginatedBreeds(items: [persian], currentPage: 2, lastPage: 3),
        );
      });

      final cubit = BreedsCubit(repository);
      await cubit.loadInitial();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      unawaited(cubit.loadMore());
      unawaited(cubit.loadMore());
      await Future<void>.delayed(const Duration(milliseconds: 300));

      verify(() => repository.getBreedsPage(page: 2)).called(1);
      await cubit.close();
    });
  });
}
