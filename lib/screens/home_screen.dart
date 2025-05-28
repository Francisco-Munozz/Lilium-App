// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lilium_app/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _redireccionarSegunPreferencia();
  }

  Future<void> _redireccionarSegunPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    final pantalla =
        prefs.getString('pantalla_preferida') ?? 'habits'; // Valor por defecto

    Widget destino;
    if (pantalla == 'habits') {
      destino = const HabitTrackerScreen(); // Reemplaza con tu pantalla real
    } else if (pantalla == 'notas') {
      destino = const NotesScreen(); // Reemplaza con tu pantalla real
    } else {
      destino = const MainAppScreen(); // Reemplaza con tu pantalla real
    }

    // Redirige sin dejar esta pantalla en el stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla temporal mientras se redirige
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  // Lista de hábitos de ejemplo
}
