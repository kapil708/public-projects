import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boilerplate_v2/config/routes/route_names.dart';
import 'package:flutter_bloc_boilerplate_v2/core/extensions/spacing.dart';
import 'package:flutter_bloc_boilerplate_v2/core/helper/ui_helper.dart';
import 'package:flutter_bloc_boilerplate_v2/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc_boilerplate_v2/injection_container.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<SplashCubit>()..init(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    SplashCubit cubit = context.read<SplashCubit>();

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          context.goNamed(RouteName.home);
        } else if (state is SplashUnauthorised) {
          context.goNamed(RouteName.login);
        } else if (state is SplashException) {
          showAlertDialog(
            context: context,
            body: state.message,
          );
        }
      },
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "App Title",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Subtitle",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    if (state is SplashException) ...[
                      const VSpace(32),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const VSpace(8),
                      FilledButton(
                        onPressed: cubit.init,
                        child: const Text("Try Again"),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
