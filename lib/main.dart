import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lilium_app/screens/welcome_screens/login_screen.dart';
import 'package:lilium_app/screens/real_screen/contactos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _detectarPantallaInicial() async {
    final prefs = await SharedPreferences.getInstance();
    final rut = prefs.getString('rut_usuario');
    final pantallaInicial = prefs.getString('pantalla_inicial');

    if (rut != null && rut.isNotEmpty && pantallaInicial != null) {
      switch (pantallaInicial) {
        case 'ContactosScreen':
          return const ContactosScreen();
        default:
          return const ContactosScreen(); // valor por defecto si no reconoce
      }
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _detectarPantallaInicial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFFFFBF1),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Ocurrió un error cargando la app')),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
