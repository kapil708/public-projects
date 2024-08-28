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
      // check here for any condition before navigation

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        name: RouteName.home,
        builder: (context, state) => const HomePage(),
        routes: [
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
