import 'package:go_router/go_router.dart';
import 'package:travelconverter/routing/routes.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/edit_currencies_screen.dart';
import 'package:travelconverter/use_cases/main_screen/ui/main_screen.dart';

final router = GoRouter(initialLocation: Routes.home, routes: [
  GoRoute(
    path: Routes.home,
    builder: (context, state) => MainScreen(),
  ),
  GoRoute(
      path: Routes.edit, builder: (context, state) => EditCurrenciesScreen())
]);
