import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hangman_word_quest/core/extensions/text_style_extensions.dart';
import 'package:lottie/lottie.dart';

import '../../../core/assets/image_assets.dart';
import '../../../core/const/constants.dart';
import '../../../core/extensions/spacing.dart';
import '../../../injection_container.dart';
import '../../bloc/game_play/game_play_bloc.dart';

class GamePlayPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const GamePlayPage({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<GamePlayBloc>()..add(OnGamePlayInit(categoryId, categoryName)),
      child: const GamePlayView(),
    );
  }
}

class GamePlayView extends StatefulWidget {
  const GamePlayView({super.key});

  @override
  State<GamePlayView> createState() => _GamePlayViewState();
}

class _GamePlayViewState extends State<GamePlayView> {
  @override
  Widget build(BuildContext context) {
    double boxSize = (MediaQuery.sizeOf(context).width - 40) / 10;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<GamePlayBloc, GamePlayState>(
        listener: (context, state) {
          if (state is STWordFailed) {
            //showNoDataDialog(context, state.message);
            showNoDataAlertDialog(context, state.message);
          } else if (state is STAttemptOver) {
            // showFailedDialog(context);
            showFailedAlertDialog(context);
          } else if (state is STWinner) {
            //showWinnerDialog(context);
            showWinnerAlertDialog(context);
          }
        },
        builder: (context, state) {
          GamePlayBloc gBloc = context.read<GamePlayBloc>();
          int wordLength = gBloc.word.name.characters.length;
          double totalSpace = 10 * (wordLength - 1);
          double wordSize = (MediaQuery.sizeOf(context).width - 16 - totalSpace) / wordLength;
          //double wordSize = (MediaQuery.sizeOf(context).width - 32) / gBloc.word.name.characters.length;

          print("wordSize: $wordSize");
          print("word length: ${gBloc.word.name.characters.length}");

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              children: [
                // Body
                Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.home_outlined,
                            size: 40,
                          ),
                        ),
                        Text(
                          "${l10n.score} ${gBloc.userScore}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            "${l10n.level} ${gBloc.userLevel}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Figure
                    Stack(
                      children: [
                        figureImage(gBloc.attempt >= 0, ImageAssets.hmHang),
                        figureImage(gBloc.attempt >= 1, ImageAssets.hmHead),
                        figureImage(gBloc.attempt >= 2, ImageAssets.hmBody),
                        figureImage(gBloc.attempt >= 3, ImageAssets.hmRightArm),
                        figureImage(gBloc.attempt >= 4, ImageAssets.hmLeftArm),
                        figureImage(gBloc.attempt >= 5, ImageAssets.hmRightLag),
                        figureImage(gBloc.attempt >= 6, ImageAssets.hmLeftLag),
                      ],
                    ),
                    const Spacer(),

                    // Word
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...gBloc.word.name.characters.map((e) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            width: wordSize,
                            alignment: Alignment.center,
                            child: Text(
                              gBloc.correctAlphabets.contains(e.toLowerCase()) ? e.toUpperCase() : '',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          );
                        }),
                      ],
                    ),
                    const VSpace(32),

                    // Hint
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "${gBloc.categoryName}${gBloc.word.hint != null ? ': ' : ''}",
                          style: Theme.of(context).textTheme.titleMedium?.textColor(
                                Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                          children: [
                            if (gBloc.word.hint != null)
                              TextSpan(
                                text: gBloc.word.hint,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const VSpace(16),

                    // Alphabet
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...alphabetsLine1.map((e) {
                          return InkWell(
                            onTap: () {
                              if (!gBloc.correctAlphabets.contains(e.toLowerCase()) && !gBloc.wrongAlphabets.contains(e.toLowerCase())) {
                                context.read<GamePlayBloc>().add(CharacterClick(e.toLowerCase()));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: gBloc.correctAlphabets.contains(e.toLowerCase())
                                    ? Colors.green
                                    : gBloc.wrongAlphabets.contains(e.toLowerCase())
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: boxSize,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.headlineSmall?.semiBold.textColor(Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...alphabetsLine2.map((e) {
                          return InkWell(
                            onTap: () {
                              if (!gBloc.correctAlphabets.contains(e.toLowerCase()) && !gBloc.wrongAlphabets.contains(e.toLowerCase())) {
                                context.read<GamePlayBloc>().add(CharacterClick(e.toLowerCase()));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: gBloc.correctAlphabets.contains(e.toLowerCase())
                                    ? Colors.green
                                    : gBloc.wrongAlphabets.contains(e.toLowerCase())
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: boxSize,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.headlineSmall?.semiBold.textColor(Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...alphabetsLine3.map((e) {
                          return InkWell(
                            onTap: () {
                              if (!gBloc.correctAlphabets.contains(e.toLowerCase()) && !gBloc.wrongAlphabets.contains(e.toLowerCase())) {
                                context.read<GamePlayBloc>().add(CharacterClick(e.toLowerCase()));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: gBloc.correctAlphabets.contains(e.toLowerCase())
                                    ? Colors.green
                                    : gBloc.wrongAlphabets.contains(e.toLowerCase())
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: boxSize,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.headlineSmall?.semiBold.textColor(Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const VSpace(16),
                  ],
                ),

                // Loading
                if (state is STWordLoading)
                  const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showFailedAlertDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text(l10n.youLost),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(LottieAssets.sad, height: 150),
                  Text(
                    l10n.youLostMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(l10n.tryAgain),
                  onPressed: () {
                    context.read<GamePlayBloc>().add(Retry());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showWinnerAlertDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text(l10n.youWin),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(LottieAssets.win, height: 200),
                  Text(
                    l10n.youWinMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(l10n.playNext),
                  onPressed: () {
                    context.read<GamePlayBloc>().add(NextGame());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showNoDataAlertDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text(l10n.alert),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget figureImage(bool visible, String path) {
    return Visibility(
        visible: visible,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            path,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ));
  }
}
