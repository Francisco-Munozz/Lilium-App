import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lilium_app/theme/theme.dart';
import 'bullying_screen.dart';

class RecursosAyudaScreen extends StatelessWidget {
  const RecursosAyudaScreen({super.key});

  Widget _buildRecurso(
    IconData iconData,
    String title,
    String detail,
    String urlOrPhone,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () async {
        if (urlOrPhone == 'bullying') {
          // Abrir pantalla bullying
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BullyingScreen()),
          );
        } else {
          Uri uri;
          if (urlOrPhone.startsWith('http')) {
            uri = Uri.parse(urlOrPhone);
          } else if (urlOrPhone.startsWith('tel:')) {
            uri = Uri.parse(urlOrPhone);
          } else {
            // Asumir que es un número telefónico sin prefijo
            uri = Uri(scheme: 'tel', path: urlOrPhone);
          }

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir el recurso')),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(iconData, size: 30, color: AppColors.primaryText),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text('Recursos y Ayuda'),
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
          children: [
            _buildRecurso(
              Icons.report_problem_rounded,
              'Bullying: Qué hacer y cómo reconocerlo',
              'Información para actuar y protegerse',
              'bullying',
              context,
            ),
            const SizedBox(height: 16),
            const Text(
              'Contactos de emergencia en Chile:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            _buildRecurso(
              Icons.local_hospital,
              'SAMU – Ambulancia',
              '131',
              '131',
              context,
            ),
            _buildRecurso(
              Icons.local_fire_department,
              'Bomberos',
              '132',
              '132',
              context,
            ),
            _buildRecurso(
              Icons.local_police,
              'Carabineros',
              '133',
              '133',
              context,
            ),
            _buildRecurso(
              Icons.shield,
              'PDI (Investigaciones)',
              '134',
              '134',
              context,
            ),
            _buildRecurso(
              Icons.child_care,
              'Fono Niños',
              '147',
              '147',
              context,
            ),
            _buildRecurso(
              Icons.family_restroom,
              'Fono Familia',
              '149',
              '149',
              context,
            ),
            _buildRecurso(
              Icons.woman,
              'Violencia Mujer',
              '1455',
              '1455',
              context,
            ),

            const SizedBox(height: 24),
            const Text(
              'Apoyo y contención emocional:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildRecurso(
              Icons.health_and_safety,
              'Salud Responde',
              '600 360 7777',
              'tel:6003607777',
              context,
            ),
            _buildRecurso(
              Icons.psychology,
              'Apoyo a víctimas',
              '600 818 1000',
              'tel:6008181000',
              context,
            ),
            _buildRecurso(
              Icons.group,
              'Línea Libre (infancia)',
              '1515',
              '1515',
              context,
            ),
          ],
        ),
      ),
    );
  }
}
