import 'package:flutter/material.dart';
import 'package:lilium_app/theme/theme.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/card_cajas.dart';
import 'package:lilium_app/widgets/widgets.dart';

// Pantalla principal de la app real
// El usuario puede acceder a las funcionalidades de la app (contactos de emergencia, configuración de la app, grabación manual y ayuda)
class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF1),
        elevation: 0,
        foregroundColor: AppColors.primaryText,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Row(
          children: [
            const Text('Mi Espacio Seguro'),
            const Spacer(),
            Image.asset('assets/images/lilium_logo.png', height: 45),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'No estás solo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5A5A5A),
              ),
            ),
            const SizedBox(height: 30),
            CardCajas(
              title: 'Contactos de emergencia',
              color: const Color(0xFFFFD6A5),
              icon: Icons.phone_in_talk_rounded,
              onTap: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactosScreen(),
                  ),
                );

                if (resultado == 'contactos_guardados') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('¡Contactos guardados exitosamente!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            CardCajas(
              title: 'Configuración de la aplicación',
              color: const Color(0xFFA0E7E5),
              icon: Icons.settings,
            ),
            const SizedBox(height: 16),
            CardCajas(
              title: 'Grabación manual',
              color: const Color(0xFFB4F8C8),
              icon: Icons.mic_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GrabacionManualScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CardCajas(
              title: 'Recursos y ayuda',
              color: const Color(0xFFFFC3A0),
              icon: Icons.help_outline_rounded,
            ),
            SizedBox(height: screenAlto * 0.1),
            Align(alignment: Alignment.center, child: BotonCerrarSesion()),
          ],
        ),
      ),
    );
  }
}
