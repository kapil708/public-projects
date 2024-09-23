// ignore_for_file: use_build_context_synchronously

import 'package:bloc_with_services_boilerplate/routes/route_names.dart';
import 'package:bloc_with_services_boilerplate/services/data_source/local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../injection_container.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5)).then((value) => context.goNamed(RouteName.home));
    super.initState();
  }

  void checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    String? authToken = locator.get<LocalDataSource>().getAuthToken();
    if (authToken != null && authToken.isNotEmpty) {
      context.goNamed(RouteName.home);
    } else {
      context.goNamed(RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome To \nBloc With Services",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
