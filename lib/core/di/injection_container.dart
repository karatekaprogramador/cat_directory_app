import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/breed_detail/data/repositories/cat_fact_repository.dart';
import '../../features/breed_detail/presentation/cubit/breed_detail_cubit.dart';
import '../../features/breeds/data/repositories/breed_repository.dart';
import '../../features/breeds/data/services/cat_api_service.dart';
import '../../features/breeds/presentation/bloc/breeds_bloc.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  getIt.registerLazySingleton<Dio>(ApiClient.createDio);
  getIt.registerLazySingleton<CatApiService>(() => CatApiService(getIt<Dio>()));

  getIt.registerLazySingleton<BreedRepository>(
    () => BreedRepository(getIt<CatApiService>()),
  );

  getIt.registerLazySingleton<CatFactRepository>(
    () => CatFactRepository(getIt<CatApiService>()),
  );

  getIt.registerFactory<BreedsBloc>(() => BreedsBloc(getIt<BreedRepository>()));
  getIt.registerFactory<BreedDetailCubit>(
    () => BreedDetailCubit(getIt<CatFactRepository>()),
  );
}
