import 'package:flutter/material.dart';
import 'package:lilium_app/widgets/widgets.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});
  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;
    return Card(
      color: const Color.fromARGB(255, 241, 225, 106),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: screenAlto * 0.30,
        width: screenAncho * 0.43,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Título alineado a la izquierda
          children: [
            const Text(
              "Título",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Descripción",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            LineasNotas(cantidad: 6),
          ],
        ),
      ),
    );
  }
}
