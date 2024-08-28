import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<RemoteFailure, List<ProductEntity>>> getProduct() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getProducts();
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }
}
