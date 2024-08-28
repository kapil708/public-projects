import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/image_assets.dart';
import '../../../core/route/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => context.goNamed(RouteName.home),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.cardLogo,
              height: MediaQuery.sizeOf(context).width * 0.5,
            ),
            RichText(
              text: TextSpan(
                text: "Swipe",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                children: [
                  TextSpan(
                    text: " Me",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
