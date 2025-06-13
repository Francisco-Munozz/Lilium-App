import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lilium_app/screens/screens.dart';

class SeleccionActivacionScreen extends StatefulWidget {
  const SeleccionActivacionScreen({super.key});

  @override
  State<SeleccionActivacionScreen> createState() =>
      _SeleccionActivacionScreenState();
}

class _SeleccionActivacionScreenState extends State<SeleccionActivacionScreen> {
  bool _alertaDecibeles = false;
  bool _alertaMovimiento = false;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _alertaDecibeles = prefs.getBool('alerta_decibeles') ?? false;
      _alertaMovimiento = prefs.getBool('alerta_movimiento') ?? false;
    });
  }

  Future<void> _guardarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alerta_decibeles', _alertaDecibeles);
    await prefs.setBool('alerta_movimiento', _alertaMovimiento);
  }

  void _continuar() async {
    await _guardarPreferencias();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SeleccionFachadaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        title: const Text("Selecciona métodos de alerta"),
        backgroundColor: const Color(0xFFFFD6A5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Aumento brusco de decibeles"),
              value: _alertaDecibeles,
              onChanged: (bool value) {
                setState(() {
                  _alertaDecibeles = value;
                });
              },
              activeColor: const Color(0xFFFFA69E),
            ),
            SwitchListTile(
              title: const Text("Aumento de movimiento"),
              value: _alertaMovimiento,
              onChanged: (bool value) {
                setState(() {
                  _alertaMovimiento = value;
                });
              },
              activeColor: const Color(0xFFFFA69E),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _continuar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD6A5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "Continuar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
