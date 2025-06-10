import 'package:flutter/material.dart';
import 'package:lilium_app/theme/theme.dart';

class BullyingScreen extends StatelessWidget {
  const BullyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text('Bullying: Cómo actuar'),
        backgroundColor: const Color(0xFFFFFBF1),
        foregroundColor: AppColors.primaryText,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: const [
            Text(
              '¿Cómo reconocer el bullying?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              'El bullying ocurre cuando una persona recibe agresiones físicas, verbales o psicológicas de forma reiterada por parte de otros. Puede manifestarse como:',
              style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A)),
            ),
            SizedBox(height: 12),
            Text('• Insultos o burlas constantes.'),
            Text('• Golpes o empujones.'),
            Text('• Exclusión social.'),
            Text('• Amenazas o intimidación.'),
            Text('• Acoso a través de redes sociales (ciberbullying).'),
            SizedBox(height: 24),
            Text(
              '¿Qué puedes hacer?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              'Si tú o alguien cercano está viviendo estas situaciones:',
              style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A)),
            ),
            SizedBox(height: 12),
            Text('• No te quedes en silencio.'),
            Text('• Habla con un adulto de confianza.'),
            Text('• Llama a los números de ayuda disponibles.'),
            Text('• Si eres testigo, apoya a la persona afectada.'),
            Text('• No compartas contenido que humille a otros.'),
            SizedBox(height: 24),
            Text(
              'Recuerda: Todos merecemos respeto y nadie debe pasar por esto solo.',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
