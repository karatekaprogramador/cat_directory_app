import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection_container.dart';
import '../features/breed_detail/presentation/pages/breed_detail_page.dart';
import '../features/breeds/domain/entities/breed.dart';
import '../features/breeds/presentation/bloc/breeds_bloc.dart';
import '../features/breeds/presentation/bloc/breeds_event.dart';
import '../features/breeds/presentation/pages/breeds_page.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const breedDetail = '/breed-detail';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<BreedsBloc>()..add(const BreedsStarted()),
            child: const BreedsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.breedDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Breed) {
            return const _RouteErrorPage(
              message: 'No se encontró información de la raza seleccionada.',
            );
          }

          return BreedDetailPage(breed: extra);
        },
      ),
    ],
  );
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta inválida')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
