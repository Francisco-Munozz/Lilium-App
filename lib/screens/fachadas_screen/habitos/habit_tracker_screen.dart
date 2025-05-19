import 'package:flutter/material.dart';
import 'package:lilium_app/models/habit.dart';
import 'package:lilium_app/screens/fachadas_screen/habitos/habit_detail_screen.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'package:lilium_app/screens/fachadas_screen/habitos/add_habit_screen.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreen();
}

class _HabitTrackerScreen extends State<HabitTrackerScreen> {
  final List<Habit> habits = [
    Habit(name: 'Beber agua', emoji: '💧'),
    Habit(name: 'Leer 30 mins', emoji: '📖'),
    Habit(name: 'Ejercicio', emoji: '🏃‍♀️'),
    Habit(name: 'Meditación', emoji: '🧘‍♂️'),
  ];

  // Racha semanal (true = completado, false = no completado)
  final streakStatus = [true, true, true, true, false, false, false];
  // Racha actual (número de días seguidos)
  final currentStreak = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text(
          '¡Bienvenido de nuevo!',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 135, 127),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu racha semanal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              WeekStreak(
                daysCompleted: streakStatus,
              ), // Widget para mostrar la racha semanal
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '🔥 Racha actual: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    '$currentStreak días seguidos', // Muestra la racha actual
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Hábitos diarios',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              // Listado de hábitos
              Column(
                children:
                    habits.map((habit) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color:
                                habit
                                        .isDone // Cambia el color de fondo según el estado del hábito
                                    ? const Color(0xFFB5E48C)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // Sombra para el efecto de profundidad
                                color: const Color(0x20000000),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            // ListTile para mostrar cada hábito
                            leading: Text(
                              habit.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              habit.name,
                              style: TextStyle(
                                color:
                                    habit.isDone
                                        ? Colors.black87
                                        : const Color(0xFF333333),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Checkbox(
                              // Checkbox para marcar el hábito como completado
                              value: habit.isDone,
                              onChanged: (value) {
                                setState(() {
                                  habit.isDone = value!;
                                });
                              },
                            ),
                            onTap: () {
                              // Navegar a la pantalla de detalles del hábito
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          HabitDetailScreen(habit: habit),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 20),
              GestureDetector(
                // Botón para agregar un nuevo hábito
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Navegar a la pantalla de agregar hábito
                      builder: (context) => const AddHabitScreen(),
                    ),
                  );
                },
                child: Container(
                  // Contenedor para el botón
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x20000000),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    // Contenido del botón
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFFFF6F61),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Agregar nuevo hábito',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                // Mensaje motivacional
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "¡Nunca es tarde para crear un nuevo hábito! 🌱",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
