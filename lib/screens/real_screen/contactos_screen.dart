import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/widgets.dart';

import 'package:lilium_app/theme/theme.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});
  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contacto1Controller = TextEditingController();
  final TextEditingController _contacto2Controller = TextEditingController();
  final TextEditingController _contacto3Controller = TextEditingController();

  void _guardarNota() {
    final contacto1 = _contacto1Controller.text.trim();
    final contacto2 = _contacto2Controller.text.trim();
    final contacto3 = _contacto3Controller.text.trim();

    if (contacto1.isEmpty || contacto2.isEmpty || contacto3.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Completa los campos')));
      return;
    }

    // Aquí podrías guardar la nota en una lista, base de datos o API
    Navigator.pop(context); // Volver a la pantalla anterior
  }

  @override
  void dispose() {
    _contacto1Controller.dispose();
    _contacto2Controller.dispose();
    _contacto3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF1),
        elevation: 0,
        foregroundColor: AppColors.primaryText,
        title: Text("Contacto de emergencia"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenAlto * 0.04),
              CajasCircularesColores(
                color: Color(0xFFFFD6A5),
                texto: const Text(
                  "Define tus contactos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                ancho: screenAncho * 0.69,
              ),
              SizedBox(height: screenAlto * 0.04),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF1),
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenAlto * 0.05),
                    ContactosWidget(index: "1.", telefono: "9 3733 7524"),
                    SizedBox(height: screenAlto * 0.06),
                    ContactosWidget(index: "2.", telefono: "9 3733 7524"),
                    SizedBox(height: screenAlto * 0.06),
                    ContactosWidget(index: "3.", telefono: "9 3733 7524"),
                    SizedBox(height: screenAlto * 0.05),
                  ],
                ),
              ),
              SizedBox(height: screenAlto * 0.05),
              CajasCircularesColores(
                color: Color(0xFFFFD6A5),
                texto: const Text(
                  "Confirmar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                ancho: screenAncho * 0.4,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainAppScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
