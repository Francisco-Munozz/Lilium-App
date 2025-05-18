import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HabitCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.check_circle_outline),
        onTap: onTap,
      ),
    );
  }
}
