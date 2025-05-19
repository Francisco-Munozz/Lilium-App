import 'package:flutter/material.dart';

class LineasNotas extends StatelessWidget {
  final int cantidad;
  final double separacion;

  const LineasNotas({
    super.key,
    required this.cantidad,
    this.separacion = 12.0, // espacio entre líneas por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        cantidad,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: separacion),
          child: Container(
            height: 1.5,
            color: const Color.fromARGB(100, 97, 97, 97),
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
