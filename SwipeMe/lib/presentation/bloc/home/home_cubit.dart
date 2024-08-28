import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/product_usercase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductUseCase productUseCase;

  HomeCubit({required this.productUseCase}) : super(HomeInitial());

  List<ProductEntity> productList = [];
  ProductEntity? selectedProduct;

  void init() async {
    emit(Loading());
    final response = await productUseCase.getProduct();
    response.fold(
      (failure) => emit(Failed(failure.message)),
      (data) {
        if (data.isNotEmpty) {
          productList = data;
          selectedProduct = productList[0];
        }
        emit(Success());
      },
    );
  }

  void onCardChange(int index) {
    emit(Init());
    selectedProduct = productList[index];
    emit(Done());
  }
}
