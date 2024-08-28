import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/route/app_router.dart';
import 'core/theme/color_schemes.g.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setUp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Do not put AppRouter().router inside build method -> it will start the from initial route '/' on "Hot Reload"
  final GoRouter _router = AppRouter().router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Hangman Word Quest",
      routerConfig: _router,

      /// Theming
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}
