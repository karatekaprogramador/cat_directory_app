import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../domain/entities/breed.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';
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
      context.read<BreedsBloc>().add(const BreedsLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<BreedsBloc, BreedsState>(
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Text(
                    'Cat Directory',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Explora razas y conoce más de cada una.',
                    style: TextStyle(color: Color(0xFF677489), fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      context.read<BreedsBloc>().add(
                        BreedsSearchChanged(value),
                      );
                    },
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
                onPressed: () {
                  context.read<BreedsBloc>().add(const BreedsStarted());
                },
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
      onRefresh: () async {
        context.read<BreedsBloc>().add(const BreedsRefreshed());
      },
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          breed.breed,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B2430),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            breed.country,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
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
