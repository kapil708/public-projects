import 'package:clean_architecture_demo/core/network/network_info.dart';
import 'package:clean_architecture_demo/core/util/input_converter.dart';
import 'package:clean_architecture_demo/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_demo/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_demo/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_demo/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_demo/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_demo/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_demo/presentation/logic/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> setup() async {
  //! Features - Number Trivia
  locator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: locator(),
      getRandomNumberTrivia: locator(),
      inputConverter: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => GetConcreteNumberTrivia(locator()));
  locator.registerLazySingleton(() => GetRandomNumberTrivia(locator()));

  // Repository
  locator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: locator(),
      networkInfo: locator(),
      remoteDataSource: locator(),
    ),
  );

  // Data sources
  locator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: locator()),
  );

  //! Core
  locator.registerLazySingleton(() => InputConverter());
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
