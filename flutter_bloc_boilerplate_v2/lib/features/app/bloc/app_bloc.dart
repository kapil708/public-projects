import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_boilerplate_v2/core/enums/app_theme_mode.dart';
import 'package:flutter_bloc_boilerplate_v2/core/enums/language.dart';
import 'package:flutter_bloc_boilerplate_v2/injection_container.dart';
import 'package:flutter_bloc_boilerplate_v2/services/data_source/local_data_source.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<OnAppInit>(onAppInit);
    on<ChangeLanguage>(onChangeLanguage);
    on<ChangeThemeMode>(onChangeThemeMode);
  }

  onChangeLanguage(ChangeLanguage event, Emitter<AppState> emit) async {
    await locator.get<LocalDataSource>().cacheLanguage(event.selectedLanguage.value.languageCode);
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  onChangeThemeMode(ChangeThemeMode event, Emitter<AppState> emit) async {
    await locator.get<LocalDataSource>().cacheThemeMode(event.selectedThemeMode.value.name);
    emit(state.copyWith(selectedThemeMode: event.selectedThemeMode));
  }

  onAppInit(OnAppInit event, Emitter<AppState> emit) async {
    final selectedLanguage = locator.get<LocalDataSource>().getLanguage();
    final selectedThemeMode = locator.get<LocalDataSource>().getThemeMode();

    emit(state.copyWith(
      selectedLanguage: selectedLanguage != null ? Language.values.where((item) => item.value.languageCode == selectedLanguage).first : Language.english,
      selectedThemeMode: selectedThemeMode != null ? AppThemeMode.values.where((themeMode) => themeMode.value.name == selectedThemeMode).first : AppThemeMode.system,
    ));
  }
}
