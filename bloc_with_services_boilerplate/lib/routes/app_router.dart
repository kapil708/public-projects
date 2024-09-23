import 'package:go_router/go_router.dart';

import 'page_list.dart';
import 'route_names.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    errorBuilder: (context, state) => const Page404(),
    redirect: (context, state) async {
      /*if (state.location != '/' && state.location != '/login') {
        bool isLogin = await cache.isLogin();
        return isLogin ? null : '/login';
      } else {
        return null;
      }*/

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboard',
        name: RouteName.onBoard,
        builder: (context, state) => const OnBoardPage(),
        routes: [
          GoRoute(
            path: 'login',
            name: RouteName.login,
            builder: (context, state) => const LoginPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: RouteName.home,
        builder: (context, state) => const SplashPage(), //HomePage()
        routes: [
          GoRoute(
            path: 'settings',
            name: RouteName.settings,
            builder: (context, state) => const SplashPage(), // SettingsPage()
          ),
        ],
      ),
    ],
  );
}
