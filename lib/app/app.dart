import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../core/theme/app_theme.dart';
import '../features/breeds/presentation/cubit/breeds_cubit.dart';
import '../features/breeds/presentation/pages/breeds_page.dart';

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key, this.loadInitialBreeds = true});

  final bool loadInitialBreeds;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Directory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: BlocProvider(
        create: (_) {
          final cubit = getIt<BreedsCubit>();
          if (loadInitialBreeds) {
            cubit.loadInitial();
          }
          return cubit;
        },
        child: const BreedsPage(),
      ),
    );
  }
}
