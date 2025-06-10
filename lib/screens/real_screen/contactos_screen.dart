import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilium_app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});
  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  final TextEditingController _contacto1Controller = TextEditingController();
  final TextEditingController _contacto2Controller = TextEditingController();
  final TextEditingController _contacto3Controller = TextEditingController();
  bool _cargando = true;
  List<String> listaDeContactosId = [];

  @override
  void initState() {
    super.initState();
    _cargarContactosDesdeFirestore();
  }

  bool esNumeroValido(String numero) {
    return RegExp(r'^\+569\d{8}$').hasMatch(numero);
  }

  Future<void> _cargarContactosDesdeFirestore() async {
    setState(() => _cargando = true);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Traemos como máximo 3 teléfonos asociados al usuario
    final snap =
        await FirebaseFirestore.instance
            .collection('Contactos')
            .where('ID_Usuarios', arrayContains: userId)
            .limit(3)
            .get();

    final telefonos = snap.docs
        .map((d) => (d['Telefono'] as String?) ?? '')
        .toList(growable: false);

    if (telefonos.isEmpty) {
      _contacto1Controller.text = '';
      _contacto2Controller.text = '';
      _contacto3Controller.text = '';
    } else {
      _contacto1Controller.text = telefonos[0].replaceFirst('+569', '');
      _contacto2Controller.text = telefonos[1].replaceFirst('+569', '');
      _contacto3Controller.text = telefonos[2].replaceFirst('+569', '');
    }
    setState(() => _cargando = false);
  }

  Future<void> _guardarContactos() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Normalizamos y filtramos vacíos
    final numeros = {
      _formatearNumero(_contacto1Controller.text),
      _formatearNumero(_contacto2Controller.text),
      _formatearNumero(_contacto3Controller.text),
    }..removeWhere((n) => n.isEmpty);

    // 💡 Solo permitimos 3
    if (numeros.length != 3) {
      _showSnack('Debes ingresar exactamente 3 números');
      return;
    }
    if (numeros.any((n) => !esNumeroValido(n))) {
      _showSnack('Formato incorrecto: usa +569XXXXXXXX');
      return;
    }

    // --- SINCRONIZAMOS ---
    final batch = FirebaseFirestore.instance.batch();
    final coleccion = FirebaseFirestore.instance.collection('Contactos');

    // 1. Contactos que YA tenía el usuario → quitamos los que dejó de usar
    final actuales =
        await coleccion.where('ID_Usuarios', arrayContains: userId).get();

    for (final doc in actuales.docs) {
      final tel = doc['Telefono'] as String;
      if (!numeros.contains(tel)) {
        batch.update(doc.reference, {
          'ID_Usuarios': FieldValue.arrayRemove([userId]),
        });
      }
    }

    // 2. Números nuevos o existentes → aseguramos que contengan el userId
    for (final numero in numeros) {
      final q =
          await coleccion.where('Telefono', isEqualTo: numero).limit(1).get();

      if (q.docs.isEmpty) {
        // No existía → lo creamos
        final ref = coleccion.doc(); // id automático
        batch.set(ref, {
          'Telefono': numero,
          'ID_Usuarios': [userId],
        });
      } else {
        // Existe → nos aseguramos de estar en ID_Usuarios
        final ref = q.docs.first.reference;
        batch.update(ref, {
          'ID_Usuarios': FieldValue.arrayUnion([userId]),
        });
      }
    }

    await batch.commit();
    Navigator.pop(context, true);
  }

  // Helper
  String _formatearNumero(String sinPrefijo) =>
      sinPrefijo.trim().isEmpty ? '' : '+569${sinPrefijo.trim()}';

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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
    if (_cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // ⏳ Indicador de carga
        ),
      );
    }

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
                  border: Border.all(
                    color: Color.fromARGB(100, 255, 255, 255),
                    width: 2,
                  ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "1.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        CajasCircularesColores(
                          color: Color(0xFFFFFBF1),
                          texto: Text(
                            "+569",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          ancho: screenAncho * 0.2,
                        ),
                        SizedBox(
                          width: screenAncho * 0.4,
                          height: screenAlto * 0.05,
                          child: TextFormField(
                            controller: _contacto1Controller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              hintText: ' Ej: 12345678',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFBF1),
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenAlto * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "2.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        CajasCircularesColores(
                          color: Color(0xFFFFFBF1),
                          texto: Text(
                            "+569",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          ancho: screenAncho * 0.2,
                        ),
                        SizedBox(
                          width: screenAncho * 0.4,
                          height: screenAlto * 0.05,
                          child: TextFormField(
                            controller: _contacto2Controller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              hintText: 'Ej: 12345678',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFBF1),
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenAlto * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "3.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        CajasCircularesColores(
                          color: Color(0xFFFFFBF1),
                          texto: Text(
                            "+569",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          ancho: screenAncho * 0.2,
                        ),
                        SizedBox(
                          width: screenAncho * 0.4,
                          height: screenAlto * 0.05,
                          child: TextFormField(
                            controller: _contacto3Controller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              hintText: 'Ej: 12345678',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFBF1),
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
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
                onTap: _guardarContactos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
