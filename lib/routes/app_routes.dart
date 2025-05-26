import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String habitDetail = '/habit_detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
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
