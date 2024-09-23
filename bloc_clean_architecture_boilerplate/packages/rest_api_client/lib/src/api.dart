import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'constants/api_config.dart';
import 'constants/api_exception.dart';
import 'constants/api_type.dart';

Dio dio = Dio();

class Apis {
  Apis({ApiConfig? apiConfig}) {
    //options
    dio.options
      ..baseUrl = apiConfig?.baseUrl ?? ''
      ..connectTimeout = apiConfig?.connectTimeout ?? const Duration(seconds: (35 * 1000)) // 35 seconds
      ..receiveTimeout = apiConfig?.receiveTimeout ?? const Duration(seconds: (35 * 1000)) // 35 seconds
      ..validateStatus = (int? status) {
        return status! > 0; //This will always redirect to onResponse method
      }
      ..headers = apiConfig?.headers ??
          {
            'Accept': 'application/json',
            'content-type': 'application/json',
          };

    // Add logs of dio
    if (apiConfig?.showLogs == true) dio.interceptors.add(PrettyDioLogger());
  }

  Future<dynamic> call({
    required String apiName,
    required ApiType type,
    Object? data,
    Map<String, dynamic>? queryParameters,
    String? authToken,
  }) async {
    try {
      // Add token to the request
      if (authToken != null) {
        dio.options.headers = {
          ...dio.options.headers,
          'Authorization': 'JWT $authToken',
        };
      }

      Response<dynamic>? response;

      switch (type) {
        case ApiType.get:
          response = await dio.get(apiName, data: data, queryParameters: queryParameters);
          break;
        case ApiType.post:
          response = await dio.post(apiName, data: data);
          break;
        case ApiType.delete:
          response = await dio.delete(apiName, data: data);
          break;
        case ApiType.put:
          response = await dio.put(apiName, data: data);
          break;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.data);
      } else {
        final data = jsonDecode(response.data);
        return Future.error(
          ApiException(
            statusCode: response.statusCode ?? 500,
            data: jsonDecode(response.data),
            message: data['message'] ?? 'Server exception',
          ),
        );
      }
    } catch (e) {
      return Future.error(
        ApiException(
          statusCode: e.runtimeType.hashCode,
          message: e.toString(),
        ),
      );
    }
  }
}

///Command to create files
//flutter pub run build_runner build --delete-conflicting-outputs
