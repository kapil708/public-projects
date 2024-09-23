import 'package:bloc/bloc.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/local_data_source.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/remote_data_source.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  LoginCubit({required RemoteDataSource remoteDataSource, required LocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        super(LoginInitial());

  void login() async {
    Map<String, dynamic> formData = {};
    final res = await _remoteDataSource.login(formData);
    res.fold(
      (failure) => emit(LoginFailure(failure.message ?? '')),
      (user) => emit(LoginSuccess()),
    );
  }
}
