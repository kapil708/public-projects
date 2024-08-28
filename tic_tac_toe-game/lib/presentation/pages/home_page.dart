import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/core/extensions/spacing.dart';

import '../../injection_container.dart';
import '../bloc/game_play/game_play_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<GamePlayCubit>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<GamePlayCubit, GamePlayState>(
        listener: (context, state) {
          if (state is GamePlayDraw) {
            showDrawAlertDialog(context);
          } else if (state is GamePlayWinner) {
            showWinnerAlertDialog(context, state.element);
          }
        },
        builder: (context, state) {
          GamePlayCubit gCubit = context.read<GamePlayCubit>();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Player X \n${gCubit.xScore}",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Player O \n${gCubit.oScore}",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const VSpace(16),
              Expanded(
                child: GridView.builder(
                  itemCount: 9,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => gCubit.onBoxClick(index),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: Text(
                            gCubit.boxes[index],
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              FilledButton(
                onPressed: () {
                  context.read<GamePlayCubit>().clearBoard();
                },
                child: const Text("Clear board"),
              ),
              const VSpace(32),
            ],
          );
        },
      ),
    );
  }

  void showDrawAlertDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: const Text("Draw !"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    context.read<GamePlayCubit>().clearBoard();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Play Again"),
                  onPressed: () {
                    context.read<GamePlayCubit>().playAgain();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showWinnerAlertDialog(BuildContext context, String winner) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text("\" $winner \" is Winner!!!"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    context.read<GamePlayCubit>().clearBoard();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Play Again"),
                  onPressed: () {
                    context.read<GamePlayCubit>().playAgain();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
