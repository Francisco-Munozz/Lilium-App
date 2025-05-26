import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lilium_app/models/habit.dart';
import 'package:lilium_app/theme/theme.dart';
import 'package:lilium_app/widgets/week_streak.dart';
import 'package:lilium_app/screens/screens.dart';

// Pantalla principal de la app de fachada Habit Tracker
class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreen();
}

class _HabitTrackerScreen extends State<HabitTrackerScreen> {
  // Lista de hábitos predeterminados
  final List<Habit> habits = [
    Habit(name: 'Beber 2lts de agua', emoji: '💧'),
    Habit(name: 'Leer 30 mins', emoji: '📖'),
    Habit(name: 'Meditar 10 min', emoji: '🧘‍♂️'),
    Habit(name: '15 mins de ejercicio', emoji: '🏃‍♀️'),
  ];

  // Estado y cantidad de dias complertados de la semana
  late List<bool> streakStatus;
  int currentStreak = 0;

  // Índice del día actual en el streakStatus (0 = lunes, 6 = domingo)
  int get todayIndex => DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    streakStatus = generarStreakStatus();
    currentStreak = calcularStreakActual(streakStatus);
  }

  // Funcion para verificar si todos los hábitos se cumplieron (en el día actual)
  bool allHabitsCompleted() {
    return habits.every((habit) => habit.isDone);
  }

  List<bool> generarStreakStatus() {
    // Genera el estado de la racha semanal
    //(valores aleatorios para días anteriores al actual y false para días futuros en la semana)
    final hoy = DateTime.now().weekday; // 1 = lunes, 7 = domingo
    final random = Random();

    List<bool> status = [];
    for (int i = 1; i <= 7; i++) {
      if (i < hoy) {
        // Días anteriores al actual => aleatorio
        status.add(random.nextBool());
      } else if (i == hoy) {
        // Hoy => inicialmente false (porque se actualizará según marque los hábitos como completados)
        status.add(allHabitsCompleted());
      } else {
        // Días futuros => siempre false
        status.add(false);
      }
    }
    return status;
  }

  int calcularStreakActual(List<bool> status) {
    // Calcula la racha actual
    final hoy = DateTime.now().weekday; // 1 = lunes, 7 = domingo

    // Si es lunes (=1), no hay días anteriores para contar, por lo que la racha será 0
    if (hoy <= 1) return 0;

    int streak = 0;
    for (int i = hoy - 2; i >= 0; i--) {
      // Comienza desde ayer hasta el lunes (=0)
      // Si el día está marcado como completado, se incrementa la racha
      if (status[i]) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // Función para actualizar estado de un hábito y racha
  void _updateHabitStatus(int index, bool value) {
    setState(() {
      habits[index].isDone = value;

      // Actualiza streakStatus del dia actual si todos hábitos están marcados como completos
      streakStatus[todayIndex] = allHabitsCompleted();

      // Recalcula racha actual
      currentStreak = calcularStreakActual(streakStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primaryText,
        title: Row(
          children: [
            const Text('¡Bienvenido de nuevo!'), // Titulo de la pág
            const Spacer(),
            Image.asset(
              'assets/images/habit_tracker_logo.png',
              height: 50,
            ), // Logo
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección racha semanal
            Text('Tu racha semanal', style: textTheme.titleLarge),
            const SizedBox(height: 10),
            // Widget que muestra la racha
            WeekStreak(daysCompleted: streakStatus),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('🔥 Racha actual: ', style: textTheme.bodyLarge),
                Text(
                  '$currentStreak días seguidos',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Sección listado de hábitos
            Text('Hábitos diarios', style: textTheme.titleLarge),
            const SizedBox(height: 10),
            Column(
              children:
                  habits.map((habit) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color:
                              habit.isDone
                                  ? AppColors
                                      .streakCompleted // Color verde si completado
                                  : AppColors.cardBackground, // Gris si no
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Text(
                            habit.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            habit.name,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Checkbox(
                            // Checkbox para marcar el hábito como completado
                            value: habit.isDone,
                            onChanged: (value) {
                              _updateHabitStatus(habits.indexOf(habit), value!);
                            },
                            activeColor: AppColors.accent,
                            checkColor: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),

            // Sección agregar nuevo hábito
            GestureDetector(
              onTap: () {
                // Navegar a la pantalla 'add_habit_screen' si presiona el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddHabitScreen(),
                  ),
                );
              },
              child: Container(
                // Contenedor para el botón de agregar nuevo hábito
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  // Contenido del botón (texto e icono)
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColors.accent,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Agregar nuevo hábito',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Sección frase motivacional
            const Center(
              child: Text(
                "“Nunca es tarde para crear un nuevo hábito” 🌱",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF7D7D7D),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Sección barra de navegación inferior (los botones no son funcionales)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
