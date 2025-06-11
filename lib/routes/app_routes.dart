import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const String home = '/';
  static const String homescreen = '/homescreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case homescreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Ruta no encontrada')),
              ),
        );
    }
  }
}
