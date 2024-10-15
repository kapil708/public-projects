import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc_boilerplate_v2/config/routes/route_names.dart';
import 'package:flutter_bloc_boilerplate_v2/core/error/exceptions.dart';
import 'package:flutter_bloc_boilerplate_v2/core/helper/connection_checker.dart';
import 'package:flutter_bloc_boilerplate_v2/core/helper/global.dart';
import 'package:flutter_bloc_boilerplate_v2/environment.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/local_data_source.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum APIRequestType { get, post, delete, put }

class ApiHelper {
  final Dio dio;
  final LocalDataSource localDataSource;
  final GlobalVariable globalVariable;
  final ConnectionChecker connectionChecker;

  ApiHelper({
    required this.dio,
    required this.localDataSource,
    required this.globalVariable,
    required this.connectionChecker,
  }) {
    dio.options
      ..baseUrl = Environment.apiUrl
      ..connectTimeout = const Duration(seconds: (35 * 1000)) // 35 seconds
      ..receiveTimeout = const Duration(seconds: (35 * 1000)) // 35 seconds
      ..validateStatus = (int? status) {
        return status! > 0; //This will always redirect to onResponse method
      }
      ..headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };

    dio.interceptors.add(PrettyDioLogger());
  }

  Map<String, String> headers() {
    var data = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String? authToken = localDataSource.getAuthToken();
    if (authToken != null && authToken.isNotEmpty) data['Authorization'] = "Bearer $authToken";

    log("header: $data");

    return data;
  }

  void _handleUnauthorizedUser() {
    // remove local data
    localDataSource.removeAuthToken();
    localDataSource.removeUser();

    /// TODO(Kapil) : Uncomment this and solve issue at end
    globalVariable.navState.currentContext!.goNamed(RouteName.login);
  }

  Future<T> request<T>({
    required String api,
    required APIRequestType requestType,
    required T Function(dynamic) modelFromJson,
    dynamic body,
  }) async {
    try {
      if (await connectionChecker.isConnected) {
        // set header value
        dio.options.headers = headers();

        Response response;

        switch (requestType) {
          case APIRequestType.get:
            response = await dio.get(api, queryParameters: body);
            break;
          case APIRequestType.post:
            response = await dio.post(api, data: body);
            break;
          case APIRequestType.delete:
            response = await dio.delete(api, data: body);
            break;
          case APIRequestType.put:
            response = await dio.put(api, data: body);
            break;
        }

        var data = jsonDecode(response.data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return modelFromJson(data);
        } else {
          if (response.statusCode == 401) {
            _handleUnauthorizedUser();
          }

          return Future.error(
            RemoteException(
              statusCode: response.statusCode ?? 500,
              message: data['message'] ?? (response.statusCode == 422 ? 'Validation failed' : 'Server exception'),
              errors: data['errors'],
            ),
          );
        }
      } else {
        return Future.error(
          RemoteException(
            statusCode: 12163,
            message: 'No internet connection.',
          ),
        );
      }
    } on Exception catch (e) {
      return Future.error(
        RemoteException(
          statusCode: e.runtimeType.hashCode,
          message: e.toString(),
        ),
      );
    }
  }
}
