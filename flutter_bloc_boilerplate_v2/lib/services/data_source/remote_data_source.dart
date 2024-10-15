import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_boilerplate_v2/core/error/exceptions.dart';
import 'package:flutter_bloc_boilerplate_v2/core/error/failures.dart';

import 'api_helper.dart';
import 'api_methods.dart';

class RemoteDataSource {
  final ApiHelper apiHelper;

  RemoteDataSource({required this.apiHelper});

  Future<Either<RemoteFailure, Map<String, dynamic>>> login(Map<String, dynamic> body) async {
    try {
      final response = await apiHelper.request(
        body: body,
        api: ApiMethods.login,
        requestType: APIRequestType.post,
        modelFromJson: (data) => Map<String, dynamic>.from(data['data']),
      );
      return Right(response);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(statusCode: e.statusCode, message: e.message, errors: e.errors));
    } catch (e) {
      return Left(RemoteFailure(statusCode: e.runtimeType.hashCode, message: e.toString()));
    }
  }

  Future<Either<RemoteFailure, List<Map<String, dynamic>>>> getDiningZones() async {
    try {
      final response = await apiHelper.request(
        api: ApiMethods.diningZones,
        requestType: APIRequestType.get,
        modelFromJson: (data) => List<Map<String, dynamic>>.from(data['data']),
      );
      return Right(response);
    } on RemoteException catch (e) {
      return Left(RemoteFailure(statusCode: e.statusCode, message: e.message, errors: e.errors));
    } catch (e) {
      return Left(RemoteFailure(statusCode: e.runtimeType.hashCode, message: e.toString()));
    }
  }
}
