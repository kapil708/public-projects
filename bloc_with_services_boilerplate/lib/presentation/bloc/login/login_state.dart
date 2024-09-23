part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class LoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginUpdate extends LoginState {
  final DateTime dateTime;

  const LoginUpdate(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
