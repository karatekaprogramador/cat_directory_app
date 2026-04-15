import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/theme_mode_cubit.dart';
import '../../domain/entities/breed.dart';
import '../cubit/breeds_cubit.dart';
import '../cubit/breeds_state.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<BreedsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<BreedsCubit, BreedsState>(
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null && message.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cat Directory',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      BlocBuilder<ThemeModeCubit, ThemeMode>(
                        builder: (context, themeMode) {
                          final isDark = themeMode == ThemeMode.dark;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Switch.adaptive(
                                value: isDark,
                                onChanged: (value) {
                                  context.read<ThemeModeCubit>().setDarkMode(
                                    value,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Explora razas y conoce más de cada una.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: context.read<BreedsCubit>().onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Buscar raza...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BreedsState state) {
    if (state.status == BreedsStatus.loading && state.breeds.isEmpty) {
      return const _LoadingList();
    }

    if (state.status == BreedsStatus.failure && state.breeds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 34,
                color: Color(0xFF7A8699),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'No se pudo cargar la información.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => context.read<BreedsCubit>().loadInitial(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.visibleBreeds.isEmpty) {
      return const Center(
        child: Text('No se encontraron razas con ese filtro.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BreedsCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: state.visibleBreeds.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.visibleBreeds.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final breed = state.visibleBreeds[index];
          return _BreedTile(
            breed: breed,
            onTap: () {
              context.push(AppRoutes.breedDetail, extra: breed);
            },
          );
        },
      ),
    );
  }
}

class _BreedTile extends StatelessWidget {
  const _BreedTile({required this.breed, required this.onTap});

  final Breed breed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final heroTag = 'breed-card-${breed.breed}-${breed.country}';

    return Hero(
      tag: heroTag,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            breed.breed,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              breed.country,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: const SizedBox(height: 76),
        );
      },
    );
  }
}
