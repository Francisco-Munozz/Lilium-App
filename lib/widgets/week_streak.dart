import 'package:flutter/material.dart';

class WeekStreak extends StatelessWidget {
  final List<bool> daysCompleted;

  const WeekStreak({super.key, required this.daysCompleted});

  @override
  Widget build(BuildContext context) {
    // Widget para mostrar la racha semanal
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return Column(
          children: [
            Text(
              days[index], // Días de la semana
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color:
                    daysCompleted[index]
                        ? Color(0xFF6CBB3C)
                        : Colors
                            .grey[300], // Color verde si el día está completado y gris si no
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        );
      }),
    );
  }
}
