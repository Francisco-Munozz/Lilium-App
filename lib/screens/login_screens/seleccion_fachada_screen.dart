import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lilium_app/screens/screens.dart';

class SeleccionFachadaScreen extends StatelessWidget {
  const SeleccionFachadaScreen({super.key});

  Future<void> _guardarPreferencia(
    BuildContext context,
    String pantalla,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pantalla_preferida', pantalla);

    // Redirige a HomeScreen que hará la redirección real
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text("Selecciona tu pantalla inicial"),
        backgroundColor: const Color(0xFFFFD6A5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _guardarPreferencia(context, 'habits'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD6A5),
              ),
              child: const Text(
                "Seguimiento de Hábitos",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _guardarPreferencia(context, 'notas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD6A5),
              ),
              child: const Text("Notas", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
