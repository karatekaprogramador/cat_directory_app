import 'package:cat_directory_app/features/breed_detail/data/repositories/cat_fact_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/breed_detail/presentation/cubit/breed_detail_cubit.dart';
import '../../features/breeds/data/repositories/breed_repository.dart';
import '../../features/breeds/data/services/breeds_cache_service.dart';
import '../../features/breeds/data/services/cat_api_service.dart';
import '../../features/breeds/presentation/cubit/breeds_cubit.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<Dio>(ApiClient.createDio);
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<CatApiService>(() => CatApiService(getIt<Dio>()));
  getIt.registerLazySingleton<BreedsCacheService>(
    () => BreedsCacheService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<BreedRepository>(
    () => BreedRepository(getIt<CatApiService>(), getIt<BreedsCacheService>()),
  );

  getIt.registerLazySingleton<CatFactRepository>(
    () => CatFactRepository(getIt<CatApiService>()),
  );

  getIt.registerFactory<BreedsCubit>(
    () => BreedsCubit(getIt<BreedRepository>()),
  );
  getIt.registerFactory<BreedDetailCubit>(
    () => BreedDetailCubit(getIt<CatFactRepository>()),
  );
}
