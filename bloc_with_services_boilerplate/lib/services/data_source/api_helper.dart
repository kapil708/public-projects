import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc_with_services_boilerplate/core/error/exceptions.dart';
import 'package:bloc_with_services_boilerplate/core/utils/global.dart';
import 'package:bloc_with_services_boilerplate/injection_container.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/local_data_source.dart';
import 'package:http/http.dart' as http;

enum APIRequestType { get, post, postMultipart, delete }

Map<String, String> headers() {
  var data = {'Accept': 'application/json', 'Content-Type': 'application/json'};

  String? authToken = locator.get<LocalDataSource>().getAuthToken();
  if (authToken != null && authToken.isNotEmpty) data['Authorization'] = "Bearer $authToken";

  log("header: $data");

  return data;
}

Future<T> apiRequest<T>({
  required http.Client client,
  required String api,
  required APIRequestType requestType,
  required T Function(dynamic) modelFromJson,
  dynamic body,
}) async {
  try {
    log('Api url: $api');
    log('Api body: ${body is http.MultipartFile ? body.filename : jsonEncode(body)}');

    http.Response response;
    if (requestType == APIRequestType.postMultipart) {
      var request = http.MultipartRequest('POST', Uri.parse(api));
      request.files.add(body);
      request.headers.addAll(headers());
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            "{\"message\": \"Request time out\"}",
            408,
          ); // Request Timeout response status code
        },
      );
    } else if (requestType == APIRequestType.post) {
      response = await client
          .post(
        Uri.parse(api),
        body: body != null ? jsonEncode(body) : null,
        headers: headers(),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            "{\"message\": \"Request time out\"}",
            408,
          ); // Request Timeout response status code
        },
      );
    } else if (requestType == APIRequestType.delete) {
      response = await client
          .delete(
        Uri.parse(api),
        body: body != null ? jsonEncode(body) : null,
        headers: headers(),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            "{\"message\": \"Request time out\"}",
            408,
          ); // Request Timeout response status code
        },
      );
    } else {
      String queryParams = "";
      if (body != null) {
        body.forEach((k, v) {
          queryParams += "${queryParams.isEmpty ? '?' : '&'}$k=$v";
        });
      }

      api += queryParams;

      response = await client.get(Uri.parse(api), headers: headers()).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            "{\"message\": \"Request time out\"}",
            408,
          ); // Request Timeout response status code
        },
      );
    }

    // log('Api response: ${response.statusCode}, ${response.body}');

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return modelFromJson(data);
    } else {
      if (response.statusCode == 401) {
        _handleUnauthorizedUser();
      }

      return Future.error(
        RemoteException(
          statusCode: response.statusCode,
          message: data['message'] ?? (response.statusCode == 422 ? 'Validation failed' : 'Server exception'),
          errors: data['errors'],
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

void _handleUnauthorizedUser() {
  // remove local data
  LocalDataSource localDataSource = locator.get<LocalDataSource>();
  localDataSource.removeAuthToken();
  localDataSource.removeUser();

  // navigate to login
  final GlobalVariable globalVariable = locator.get<GlobalVariable>();

  /// TODO(Kapil) : Uncomment this and solve issue at end
  // globalVariable.navState.currentContext!.goNamed(RouteName.login);
}
