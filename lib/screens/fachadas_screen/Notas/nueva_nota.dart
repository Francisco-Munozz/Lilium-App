import 'package:flutter/material.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NuevaNotaScreen extends StatefulWidget {
  const NuevaNotaScreen({super.key});
  @override
  State<NuevaNotaScreen> createState() => _NuevaNotaScreenState();
}

class _NuevaNotaScreenState extends State<NuevaNotaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  Future<bool> reautenticarUsuario(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _guardarNota() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    final passwordIngresada = _descripcionController.text.trim();
    final reautenticado = await reautenticarUsuario(passwordIngresada);
    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (titulo == email && reautenticado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainAppScreen()),
      );
      return;
    }

    if (titulo.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Completa ambos campos')));
      return;
    }

    // Aquí podrías guardar la nota en una lista, base de datos o API
    Navigator.pop(context); // Volver a la pantalla anterior
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 219, 175, 72),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenAlto * 0.05,
              width: screenAncho * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color.fromARGB(255, 217, 217, 217),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Creación de nota',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 87, 76, 76),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 226, 218, 161),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 100,
              ), // para no tapar el contenido con el botón
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Card(
                    color: const Color.fromARGB(255, 241, 225, 106),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Título",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _tituloController,
                              decoration: InputDecoration(
                                hintText: 'Ej. Lista de compras',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Descripción",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descripcionController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                hintText: 'Escribe los detalles de tu nota...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: BotonGuardarNota(onTap: _guardarNota),
          ),
        ],
      ),
    );
  }
}
