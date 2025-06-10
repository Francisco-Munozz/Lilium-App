import 'package:flutter/material.dart';
import 'package:lilium_app/screens/welcome_screens/permisos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});

  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  final TextEditingController _contacto0Controller = TextEditingController();
  final TextEditingController _contacto1Controller = TextEditingController();

  Future<void> _guardarContactos() async {
    final prefs = await SharedPreferences.getInstance();

    // Si el campo está vacío, remover la key o dejar en blanco
    if (_contacto0Controller.text.trim().isEmpty) {
      await prefs.remove('contacto_0');
    } else {
      await prefs.setString('contacto_0', _contacto0Controller.text.trim());
    }

    if (_contacto1Controller.text.trim().isEmpty) {
      await prefs.remove('contacto_1');
    } else {
      await prefs.setString('contacto_1', _contacto1Controller.text.trim());
    }

    _irASeleccionPermisos();
  }

  void _irASeleccionPermisos() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PermisosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text("Contactos de Emergencia"),
        backgroundColor: const Color(0xFFFFD6A5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Text(
              "Puedes agregar hasta 2 contactos de emergencia.\nSi no agregas ninguno, se notificará al administrador en casos de emergencia.\n(Puedes editar estos contactos más adelante en la configuración)",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _contacto0Controller,
              decoration: const InputDecoration(
                labelText: "Contacto 1 (opcional)",
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contacto1Controller,
              decoration: const InputDecoration(
                labelText: "Contacto 2 (opcional)",
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _guardarContactos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD6A5),
              ),
              child: const Text(
                "Guardar y continuar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _irASeleccionPermisos,
              child: const Text("Omitir este paso"),
            ),
          ],
        ),
      ),
    );
  }
}
