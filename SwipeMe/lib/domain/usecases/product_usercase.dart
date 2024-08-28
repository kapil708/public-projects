import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class ProductUseCase {
  final ProductRepository productRepository;

  ProductUseCase({required this.productRepository});

  Future<Either<RemoteFailure, List<ProductEntity>>> getProduct() async {
    return productRepository.getProduct();
  }
}
