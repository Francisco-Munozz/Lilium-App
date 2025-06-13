import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'package:lilium_app/theme/theme.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});
  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  bool _loading = true;
  List<String> contactos = ["", ""];

  @override
  void initState() {
    super.initState();
    _cargarContactosDesdeFirestore();
  }

  bool esNumeroValido(String numero) {
    return RegExp(r'^\+569\d{8}$').hasMatch(numero);
  }

  String _formatearNumero(String sinPrefijo) =>
      sinPrefijo.trim().isEmpty ? '' : '+569${sinPrefijo.trim()}';

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _cargarContactosDesdeFirestore() async {
    setState(() => _loading = true);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final snap =
        await FirebaseFirestore.instance
            .collection('Contactos')
            .where('ID_Usuarios', arrayContains: userId)
            .limit(2)
            .get();

    final telefonos =
        snap.docs.map((d) => (d['Telefono'] as String?) ?? '').toList();

    setState(() {
      for (int i = 0; i < 2; i++) {
        contactos[i] =
            i < telefonos.length ? telefonos[i].replaceFirst('+569', '') : '';
      }
      _loading = false;
    });
  }

  Future<void> _guardarContactos() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final numeros = {
      _formatearNumero(contactos[0]),
      _formatearNumero(contactos[1]),
    }..removeWhere((n) => n.isEmpty);

    if (numeros.any((n) => !esNumeroValido(n))) {
      _showSnack('Formato incorrecto: usa +569XXXXXXXX');
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    final coleccion = FirebaseFirestore.instance.collection('Contactos');

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
    final List<String> idContactos = [];
    for (final numero in numeros) {
      final q =
          await coleccion.where('Telefono', isEqualTo: numero).limit(1).get();

      if (q.docs.isEmpty) {
        final ref = coleccion.doc();
        batch.set(ref, {
          'Telefono': numero,
          'ID_Usuarios': [userId],
        });
      } else {
        final ref = q.docs.first.reference;
        batch.update(ref, {
          'ID_Usuarios': FieldValue.arrayUnion([userId]),
        });
        idContactos.add(ref.id);
      }
    }

    await batch.commit();
    final docUsuario = FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(userId);

    await docUsuario.update({
      'ID_Contactos': idContactos,
      'Contactos': numeros.toList(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainAppScreen()),
    );
  }

  Future<void> _editarContacto(int index) async {
    final controller = TextEditingController(text: contactos[index]);

    final nuevo = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar número de contacto'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Número',
              hintText: 'Ej: 12345678',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
            ),
          ],
        );
      },
    );

    if (nuevo != null) {
      setState(() => contactos[index] = nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenAncho = MediaQuery.of(context).size.width;
    double screenAlto = MediaQuery.of(context).size.height;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF1),
        elevation: 0,
        foregroundColor: AppColors.primaryText,
        title: const Text("Contacto de emergencia"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenAlto * 0.04),
              CajasCircularesColores(
                color: const Color(0xFFFFD6A5),
                texto: const Text(
                  "Define tus contactos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenAlto * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${index + 1}.",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: screenAncho * 0.5,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '+569 ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    contactos[index],
                                    style: const TextStyle(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black54),
                            onPressed: () => _editarContacto(index),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: screenAlto * 0.05),
              CajasCircularesColores(
                color: const Color(0xFFFFD6A5),
                texto: const Text(
                  "Confirmar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
