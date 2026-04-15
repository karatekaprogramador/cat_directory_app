import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../breeds/domain/entities/breed.dart';
import '../cubit/breed_detail_cubit.dart';
import '../cubit/breed_detail_state.dart';

class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({super.key, required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final heroTag = 'breed-card-${breed.breed}-${breed.country}';

    return BlocProvider(
      create: (_) => getIt<BreedDetailCubit>()..loadFact(),
      child: Scaffold(
        appBar: AppBar(title: Text(breed.breed)),
        body: BlocBuilder<BreedDetailCubit, BreedDetailState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Hero(
                  tag: heroTag,
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        breed.breed,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        breed.country,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _DetailCard(
                  title: 'Información de la raza',
                  children: [
                    _DetailRow(label: 'Breed', value: breed.breed),
                    _DetailRow(label: 'Country', value: breed.country),
                    _DetailRow(label: 'Origin', value: breed.origin),
                    _DetailRow(label: 'Coat', value: breed.coat),
                    _DetailRow(label: 'Pattern', value: breed.pattern),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailCard(
                  title: 'Dato curioso aleatorio',
                  children: [
                    if (state.factStatus == FactStatus.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.factStatus == FactStatus.failure)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.factError ?? 'No se pudo cargar el dato.',
                            style: const TextStyle(color: Color(0xFFB42318)),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.tonal(
                            onPressed: () =>
                                context.read<BreedDetailCubit>().loadFact(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      )
                    else
                      Text(
                        state.fact,
                        style: const TextStyle(fontSize: 15, height: 1.45),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
