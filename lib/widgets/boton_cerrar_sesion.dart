import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';

class BotonCerrarSesion extends StatelessWidget {
  const BotonCerrarSesion({super.key});

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenAncho * 0.5,
      height: screenAlto * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('¿Cerrar sesión?'),
                  content: const Text(
                    '¿Estás seguro de que quieres salir de tu cuenta?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
          );

          if (shouldLogout == true) {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        child: const Text('Cerrar sesión'),
      ),
    );
  }
}
