import 'package:go_router/go_router.dart';
import 'package:travelconverter/routing/routes.dart';
import 'package:travelconverter/use_cases/about/about_screen.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/edit_currencies_screen.dart';
import 'package:travelconverter/use_cases/home/ui/home_screen.dart';

final router = GoRouter(initialLocation: Routes.home, routes: [
  GoRoute(
    path: Routes.home,
    builder: (context, state) => MainScreen(),
  ),
  GoRoute(
      path: Routes.edit, builder: (context, state) => EditCurrenciesScreen()),
  GoRoute(path: Routes.about, builder: (context, state) => AboutScreen())
]);
