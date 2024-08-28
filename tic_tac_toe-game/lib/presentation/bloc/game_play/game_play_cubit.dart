import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_play_state.dart';

class GamePlayCubit extends Cubit<GamePlayState> {
  List<String> boxes = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int boxFilled = 0;
  bool oTure = true;

  GamePlayCubit() : super(GamePlayInitial());

  void onBoxClick(int index) {
    if (boxes[index] == '') {
      emit(GamePlayClick());
      if (oTure && boxes[index] == '') {
        boxes[index] = 'O';
        boxFilled++;
      } else if (!oTure && boxes[index] == '') {
        boxes[index] = 'X';
        boxFilled++;
      }

      oTure = !oTure;
      checkWinner();
    }
  }

  void checkWinner() {
    if (boxes[0] != '' && boxes[0] == boxes[1] && boxes[0] == boxes[2]) {
      setWinner(boxes[0]);
    } else if (boxes[3] != '' && boxes[3] == boxes[4] && boxes[3] == boxes[5]) {
      setWinner(boxes[3]);
    } else if (boxes[6] != '' && boxes[6] == boxes[7] && boxes[6] == boxes[8]) {
      setWinner(boxes[6]);
    } else if (boxes[0] != '' && boxes[0] == boxes[3] && boxes[0] == boxes[6]) {
      setWinner(boxes[0]);
    } else if (boxes[1] != '' && boxes[1] == boxes[4] && boxes[1] == boxes[7]) {
      setWinner(boxes[1]);
    } else if (boxes[2] != '' && boxes[2] == boxes[5] && boxes[2] == boxes[8]) {
      setWinner(boxes[2]);
    } else if (boxes[0] != '' && boxes[0] == boxes[4] && boxes[0] == boxes[8]) {
      setWinner(boxes[0]);
    } else if (boxes[2] != '' && boxes[2] == boxes[4] && boxes[2] == boxes[6]) {
      setWinner(boxes[2]);
    } else if (boxFilled == 9) {
      emit(GamePlayDraw());
    } else {
      emit(GamePlayClickDone());
    }
  }

  void setWinner(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    emit(GamePlayWinner(winner));
  }

  void playAgain() {
    boxes = ['', '', '', '', '', '', '', '', ''];
    boxFilled = 0;
    oTure = true;
    emit(GamePlayNew());
  }

  void clearBoard() {
    oScore = 0;
    xScore = 0;
    playAgain();
  }
}
