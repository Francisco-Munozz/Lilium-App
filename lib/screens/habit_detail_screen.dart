import 'package:flutter/material.dart';
import 'package:lilium_app/models/habit.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: Center(
        child: Text(
          'Detalle del hábito: ${habit.name}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
