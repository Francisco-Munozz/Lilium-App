import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/habit_detail_screen.dart';
import '../models/habit.dart';

class AppRoutes {
  static const String home = '/';
  static const String habitDetail = '/habit_detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case habitDetail:
        final habit = settings.arguments as Habit;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habit: habit),
        );

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
