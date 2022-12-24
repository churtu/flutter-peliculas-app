import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/screens/screens.dart';

class AppRouter {
  static const String initialRoute = 'home';

  static final appRoutes = <AppRoute>[
    AppRoute(
      name: 'home', 
      screen: const HomeScreen()
    ),
    AppRoute(
      name: 'details', 
      screen: const DetailsScreen()
    )
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes(){
    Map<String, Widget Function(BuildContext)> routes = {};
    for (final route in appRoutes) {
      routes.addAll({
        route.name: (context) => route.screen
      });
    }
    return routes;
  }
}