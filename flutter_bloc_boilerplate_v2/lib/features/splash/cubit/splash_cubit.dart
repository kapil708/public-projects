import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/local_data_source.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final LocalDataSource localDataSource;

  SplashCubit({
    required this.localDataSource,
  }) : super(SplashInitial());

  void init() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      var authToken = localDataSource.getAuthToken();
      if (authToken == null || authToken.trim().isEmpty) {
        emit(SplashUnauthorised());
      } else {
        emit(SplashAuthenticated());
      }
    } on Exception catch (e) {
      emit(SplashException(e.toString()));
    }
  }
}
