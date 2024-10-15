import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boilerplate_v2/features/app/bloc/app_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'config/routes/app_router.dart';
import 'config/theme/color_schemes.g.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Do not put AppRouter().router inside build method -> it will start the from initial route '/' on "Hot Reload"
  final GoRouter _router = AppRouter().router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<AppBloc>()..add(OnAppInit()),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Bloc Boilerplate V2",
            routerConfig: _router,

            /// Theming
            themeMode: state.selectedThemeMode.value,
            theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

            /// Localization
            locale: state.selectedLanguage.value,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          );
        },
      ),
    );
  }
}
