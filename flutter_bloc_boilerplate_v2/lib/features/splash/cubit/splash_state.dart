part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();
}

final class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

final class SplashAuthenticated extends SplashState {
  @override
  List<Object> get props => [];
}

final class SplashUnauthorised extends SplashState {
  @override
  List<Object> get props => [];
}

final class SplashException extends SplashState {
  final String message;

  const SplashException(this.message);

  @override
  List<Object> get props => [message];
}
