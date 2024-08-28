part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class Init extends HomeState {
  @override
  List<Object> get props => [];
}

class Done extends HomeState {
  @override
  List<Object> get props => [];
}

class Loading extends HomeState {
  @override
  List<Object> get props => [];
}

class Success extends HomeState {
  @override
  List<Object> get props => [];
}

class Failed extends HomeState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}
