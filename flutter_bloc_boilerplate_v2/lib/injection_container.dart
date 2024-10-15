import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc_boilerplate_v2/core/helper/connection_checker.dart';
import 'package:flutter_bloc_boilerplate_v2/core/helper/global.dart';
import 'package:flutter_bloc_boilerplate_v2/features/app/bloc/app_bloc.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/api_helper.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/local_data_source.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> setUp() async {
  // Features
  // locator.registerFactory(() => SplashCubit(localDataSource: locator()));
  // locator.registerFactory(() => LoginCubit(appCubit: locator(), remoteDataSource: locator(), localDataSource: locator()));

  // Feature with lazy
  locator.registerLazySingleton(() => AppBloc());

  // Data source
  locator.registerLazySingleton(() => RemoteDataSource(apiHelper: locator()));
  locator.registerLazySingleton(() => LocalDataSource(sharedPreferences: locator()));

  // Core
  locator.registerLazySingleton(() => GlobalVariable());
  locator.registerLazySingleton(() => ApiHelper(dio: locator(), localDataSource: locator(), globalVariable: locator(), connectionChecker: locator()));
  locator.registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImpl(connectivity: locator()));

  // Services
  // locator.registerLazySingleton(() => HiveDB());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton(() => Dio());
}
