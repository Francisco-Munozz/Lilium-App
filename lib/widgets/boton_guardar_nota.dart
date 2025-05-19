import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';

class BotonGuardarNota extends StatelessWidget {
  const BotonGuardarNota({super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotesScreen()),
        );
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 60,
        width: 160,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 219, 175, 72),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Agregar Nota',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 87, 76, 76),
              ),
            ),
            const Icon(Icons.check_box_outlined),
          ],
        ),
      ),
    );
  }
}
