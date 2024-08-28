import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'data/data_sources/local_data_source.dart';
import 'data/data_sources/remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/product_usercase.dart';
import 'presentation/bloc/home/home_cubit.dart';

final GetIt locator = GetIt.instance;

Future<void> setUp() async {
  // Features
  locator.registerFactory(() => HomeCubit(productUseCase: locator()));

  // Use case
  locator.registerLazySingleton(() => ProductUseCase(productRepository: locator()));

  // Repositories
  locator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: locator(), networkInfo: locator()));

  // Data source
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sharedPreferences: locator()));

  // Core
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnection: locator()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => InternetConnection());
}
