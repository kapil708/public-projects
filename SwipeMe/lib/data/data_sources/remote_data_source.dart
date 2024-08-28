import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../models/product/product_model.dart';
import 'api_methods.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

Map<String, String>? get _headers => {'Accept': 'application/json', 'Content-Type': 'application/json'};

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final http.Response response = await client.get(
      Uri.parse(ApiMethods.products),
      headers: _headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data.map<ProductModel>((d) => ProductModel.fromJson(d)).toList();
    } else {
      return Future.error(handleErrorResponse(response));
    }
  }
}

Exception handleErrorResponse(http.Response response) {
  var data = jsonDecode(response.body);

  return RemoteException(
    statusCode: response.statusCode,
    message: data['message'] ?? response.statusCode == 422 ? 'Validation failed' : 'Server exception',
  );
}

Uri getUrlWithParams(String url, Map<String, dynamic> queryParameters) {
  String urlParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');

  if (urlParams.isNotEmpty) {
    url += '?$urlParams';
  }

  return Uri.parse(url);
}
