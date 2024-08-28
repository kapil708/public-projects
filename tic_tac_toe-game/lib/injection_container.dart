import 'package:get_it/get_it.dart';
import 'package:tic_tac_toe/presentation/bloc/game_play/game_play_cubit.dart';

final GetIt locator = GetIt.instance;

Future<void> setUp() async {
  locator.registerFactory(() => GamePlayCubit());
}
