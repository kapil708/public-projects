import 'package:bloc_with_services_boilerplate/core/error/exceptions.dart';
import 'package:bloc_with_services_boilerplate/core/error/failures.dart';
import 'package:bloc_with_services_boilerplate/core/utils/connection_checker.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'api_helper.dart';
import 'api_methods.dart';

class RemoteDataSource {
  final http.Client client;
  final ConnectionChecker connectionChecker;

  RemoteDataSource({
    required this.client,
    required this.connectionChecker,
  });

  Future<Either<RemoteFailure, Map<String, dynamic>>> login(Map<String, dynamic> body) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await apiRequest(
          body: body,
          client: client,
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
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }

  Future<Either<RemoteFailure, Map<String, dynamic>>> inventoryDispense(Map<String, dynamic> body) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await apiRequest(
          body: body,
          client: client,
          api: ApiMethods.inventoryDispense,
          requestType: APIRequestType.post,
          modelFromJson: (data) => Map<String, dynamic>.from(data),
        );
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message, errors: e.errors));
      } catch (e) {
        return Left(RemoteFailure(statusCode: e.runtimeType.hashCode, message: e.toString()));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }

  Future<Either<RemoteFailure, List<Map<String, dynamic>>>> getInventory() async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await apiRequest(
          client: client,
          api: ApiMethods.inventory,
          requestType: APIRequestType.get,
          modelFromJson: (data) => List<Map<String, dynamic>>.from(data['data']),
        );
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message, errors: e.errors));
      } catch (e) {
        return Left(RemoteFailure(statusCode: e.runtimeType.hashCode, message: e.toString()));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }
}
