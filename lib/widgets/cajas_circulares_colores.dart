import 'package:flutter/material.dart';

class CajasCircularesColores extends StatelessWidget {
  final Color color;
  final Widget texto;
  final double ancho;
  final VoidCallback? onTap;

  const CajasCircularesColores({
    super.key,
    required this.color,
    required this.texto,
    required this.ancho,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenAlto = MediaQuery.of(context).size.height;

    Widget content = Container(
      width: ancho,
      height: screenAlto * 0.05,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: Colors.black, width: 1),
      ),
      alignment: Alignment.center,
      child: texto,
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: content)
        : content;
  }
}
