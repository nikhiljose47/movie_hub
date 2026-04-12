import 'package:get_it/get_it.dart';
import 'package:movie_hub/config/api_config.dart';
import 'package:movie_hub/core/network/dio_client.dart';
import 'package:movie_hub/services/movies/movie_service.dart';
import 'package:movie_hub/services/users/user_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://api.themoviedb.org/3',
      defaultQuery: {
        'api_key': ApiConfig.defaultQuery['tmdb_key'],
      },
      enableFailureSimulation: true,
    ),
    instanceName: 'movieClient',
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://reqres.in/api',
      headers: {
        'x-api-key': ApiConfig.defaultQuery['reqres_key'],
      },
    ),
    instanceName: 'userClient',
  );

  sl.registerLazySingleton<MovieService>(
    () => MovieService(sl<DioClient>(instanceName: 'movieClient')),
  );

  sl.registerLazySingleton<UserService>(
    () => UserService(sl<DioClient>(instanceName: 'userClient')),
  );
}