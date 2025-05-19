import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';

class BotonOtraNota extends StatelessWidget {
  const BotonOtraNota({super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NuevaNotaScreen()),
        );
      },

      borderRadius: BorderRadius.circular(
        50,
      ), // para el efecto de ripple redondo
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 219, 175, 72),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
