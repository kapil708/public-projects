import 'package:go_router/go_router.dart';

import '../../data/data_sources/local_data_source.dart';
import '../../injection_container.dart';
import '../../presentation/pages/settings/settings_page.dart';
import 'page_list.dart';
import 'route_names.dart';

final LocalDataSource localDatSource = locator.get<LocalDataSource>();

class AppRouter {
  final GoRouter router = GoRouter(
    errorBuilder: (context, state) => const Page404(),
    redirect: (context, state) async {
      /*if (state.location != '/' && state.location != '/login') {
        bool isLogin = await localDatSource.isLogin();
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
        path: '/login',
        name: RouteName.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: RouteName.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'gamePlay',
            name: RouteName.gamePlay,
            builder: (context, state) {
              var categoryId = state.uri.queryParameters['categoryId']!;
              var categoryName = state.uri.queryParameters['categoryName']!;

              return GamePlayPage(
                categoryId: categoryId,
                categoryName: categoryName,
              );
            },
          ),
          GoRoute(
            path: 'settings',
            name: RouteName.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
