part of 'game_play_cubit.dart';

@immutable
abstract class GamePlayState {}

class GamePlayInitial extends GamePlayState {}

class GamePlayNew extends GamePlayState {}

class GamePlayClick extends GamePlayState {}

class GamePlayClickDone extends GamePlayState {}

class GamePlayDraw extends GamePlayState {}

class GamePlayWinner extends GamePlayState {
  final String element;

  GamePlayWinner(this.element);
}
