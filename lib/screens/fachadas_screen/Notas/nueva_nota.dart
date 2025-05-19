import 'package:flutter/material.dart';
import 'package:lilium_app/widgets/widgets.dart';

class NuevaNotaScreen extends StatelessWidget {
  const NuevaNotaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 219, 175, 72),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 226, 218, 161),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenAlto * 0.03),
                AgregarNotaContenedor(),
              ],
            ),
          ),
          Positioned(bottom: 30, right: 30, child: BotonGuardarNota()),
        ],
      ),
    );
  }
}
