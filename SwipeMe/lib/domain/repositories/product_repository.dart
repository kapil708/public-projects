import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<RemoteFailure, List<ProductEntity>>> getProduct();
}
