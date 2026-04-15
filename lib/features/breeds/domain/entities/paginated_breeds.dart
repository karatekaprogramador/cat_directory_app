import 'breed.dart';

class PaginatedBreeds {
  const PaginatedBreeds({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  final List<Breed> items;
  final int currentPage;
  final int lastPage;

  bool get hasMore => currentPage < lastPage;
}
