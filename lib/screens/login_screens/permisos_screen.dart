import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lilium_app/screens/screens.dart';

class PermisosScreen extends StatefulWidget {
  const PermisosScreen({super.key});

  @override
  State<PermisosScreen> createState() => _PermisosScreenState();
}

class _PermisosScreenState extends State<PermisosScreen> {
  bool permisosListos = false;

  Future<void> solicitarPermisos() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.microphone,
          Permission.locationWhenInUse,
          Permission.notification, // Notificación Android 13+
        ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      setState(() {
        permisosListos = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Para continuar, acepta todos los permisos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        backgroundColor: const Color(0xFFFFFBF1),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Permisos necesarios:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Para protegerte correctamente en una emergencia, la app necesita acceso a:\n\n• Micrófono\n• Ubicación\n• Notificaciones',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: solicitarPermisos,
              icon: const Icon(Icons.security),
              label: const Text('Solicitar permisos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
              ),
            ),
            const SizedBox(height: 32),
            permisosListos
                ? ElevatedButton(
                  onPressed: () {
                    // Aquí navegas a la siguiente pantalla
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SeleccionActivacionScreen(),
                      ),
                    );
                  },
                  child: const Text('Continuar'),
                )
                : const Text(
                  'Debes aceptar los permisos para continuar.',
                  style: TextStyle(color: Colors.redAccent),
                ),
          ],
        ),
      ),
    );
  }
}
