import 'package:bloc_with_services_boilerplate/presentation/bloc/login/login_cubit.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/local_data_source.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/connection_checker.dart';

final GetIt locator = GetIt.instance;

Future<void> setUp() async {
  // Features
  locator.registerFactory(() => LoginCubit(remoteDataSource: locator(), localDataSource: locator()));

  // Data source
  locator.registerLazySingleton(() => RemoteDataSource(client: locator(), connectionChecker: locator()));
  locator.registerLazySingleton(() => LocalDataSource(sharedPreferences: locator()));

  // Core
  locator.registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImpl(internetConnection: locator()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => InternetConnection());
}
