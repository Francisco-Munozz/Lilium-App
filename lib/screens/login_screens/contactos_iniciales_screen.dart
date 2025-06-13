import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';

class ContactosInicialesScreen extends StatefulWidget {
  const ContactosInicialesScreen({super.key});

  @override
  State<ContactosInicialesScreen> createState() =>
      _ContactosInicialesScreenState();
}

class _ContactosInicialesScreenState extends State<ContactosInicialesScreen> {
  final TextEditingController _contacto0Controller = TextEditingController();
  final TextEditingController _contacto1Controller = TextEditingController();

  bool esNumeroValido(String numero) {
    return RegExp(r'^\+569\d{8}$').hasMatch(numero);
  }

  Future<void> _guardarContactos() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final numeros = {
      _formatearNumero(_contacto0Controller.text),
      _formatearNumero(_contacto1Controller.text),
    }..removeWhere((n) => n.isEmpty);

    if (numeros.isEmpty) {
      _showSnack('Campos vacíos, si no quiere guardar ninguno omita este paso');
      return;
    }

    if (numeros.any((n) => !esNumeroValido(n))) {
      _showSnack('Formato incorrecto: usa +569XXXXXXXX');
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    final coleccion = FirebaseFirestore.instance.collection('Contactos');

    // Para guardar los IDs de los contactos creados o existentes
    final List<String> idContactos = [];

    for (final numero in numeros) {
      final q =
          await coleccion.where('Telefono', isEqualTo: numero).limit(1).get();

      if (q.docs.isEmpty) {
        final ref = coleccion.doc(); // ID automático
        batch.set(ref, {
          'Telefono': numero,
          'ID_Usuarios': [userId],
        });
        idContactos.add(ref.id); // guardamos ID del contacto nuevo
      } else {
        final ref = q.docs.first.reference;
        batch.update(ref, {
          'ID_Usuarios': FieldValue.arrayUnion([userId]),
        });
        idContactos.add(ref.id); // guardamos ID del contacto existente
      }
    }

    await batch.commit();

    // Guardamos en el documento del usuario
    final docUsuario = FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(userId);

    await docUsuario.update({
      'ID_Contactos': idContactos,
      'Contactos': numeros.toList(),
    });

    _irASeleccionPermisos();
  }

  // Helper
  String _formatearNumero(String sinPrefijo) =>
      sinPrefijo.trim().isEmpty ? '' : '+569${sinPrefijo.trim()}';
  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _irASeleccionPermisos() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PermisosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text("Contactos de Emergencia"),
        backgroundColor: const Color(0xFFFFD6A5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Text(
              "Puedes agregar hasta 2 contactos de emergencia.\nSi no agregas ninguno, se notificará al administrador en casos de emergencia.\n(Puedes editar estos contactos más adelante en la configuración)",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _contacto0Controller,
              decoration: const InputDecoration(
                labelText: "Contacto 1 (opcional)",
                prefixText: '+569 ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contacto1Controller,
              decoration: const InputDecoration(
                labelText: "Contacto 2 (opcional)",
                prefixText: '+569 ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _guardarContactos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD6A5),
              ),
              child: const Text(
                "Guardar y continuar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _irASeleccionPermisos,
              child: const Text("Omitir este paso"),
            ),
          ],
        ),
      ),
    );
  }
}
