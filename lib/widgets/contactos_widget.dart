import 'package:flutter/material.dart';
import 'package:lilium_app/widgets/widgets.dart';

class ContactosWidget extends StatelessWidget {
  final String index;
  final String telefono;

  const ContactosWidget({
    super.key,
    required this.index,
    required this.telefono,
  });

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          index,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        CajasCircularesColores(
          color: Color(0xFFFFFBF1),
          texto: Text(
            "+56",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          ancho: screenAncho * 0.2,
        ),
        CajasCircularesColores(
          color: Color(0xFFFFFBF1),
          texto: Text(
            telefono,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          ancho: screenAncho * 0.4,
        ),
      ],
    );
  }
}
