import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool alertaDecibeles = true;
  bool alertaMovimiento = false;
  int _tapCounter = 0;
  DateTime? _lastTapTime;
  Future<void> _manejarTapOculto() async {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCounter = 1;
    } else {
      _tapCounter++;
      if (_tapCounter == 2) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('pantalla_preferida');

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferencia de inicio reiniciada')),
        );

        _tapCounter = 0; // Reiniciar contador
      }
    }
    _lastTapTime = now;
  }

  Future<void> _confirmLogout() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar cierre de sesión'),
            content: const Text('¿Estás seguro que deseas cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
    );

    if (result == true) {
      // Aquí va la lógica para cerrar sesión, p.ej. limpiar tokens, etc.

      // Redirigir a login y limpiar navegación para que no pueda volver con back
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF1),
        elevation: 0,
        foregroundColor: const Color(0xFF333333),
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: ListView(
        children: [
          // Pantalla de inicio
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pantalla de inicio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_customize),
            title: const Text('Cambiar pantalla falsa (Notas o Hábitos)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SeleccionFachadaConfgScreen(),
                ),
              );
            },
          ),
          const Divider(),

          // Seguridad
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Seguridad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pattern),
            title: const Text('Cambiar patrón de ingreso secreto'),
            onTap: () {
              // Navegar a pantalla de cambio de patrón
            },
          ),
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text('Cambiar PIN de inicio de sesión'),
            onTap: () {
              // Navegar a pantalla de cambio de PIN
            },
          ),
          const Divider(),

          // Emergencias
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Emergencias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Alerta por aumento de decibeles'),
            value: alertaDecibeles,
            activeColor: const Color(0xFFA0E7E5),
            onChanged: (value) {
              setState(() {
                alertaDecibeles = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Alerta por movimiento brusco'),
            value: alertaMovimiento,
            activeColor: const Color(0xFFA0E7E5),
            onChanged: (value) {
              setState(() {
                alertaMovimiento = value;
              });
            },
          ),
          const Divider(),

          // General
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: _confirmLogout,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Información de la app'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Lilium',
                applicationVersion: 'v1.0.0',
                applicationIcon: Image.asset(
                  'assets/images/lilium_logo.png',
                  height: 45,
                ),
                children: const [Text('Aplicación para espacios seguros.')],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Versión'),
            subtitle: const Text('v1.0.0'),
          ),
          GestureDetector(
            onTap: _manejarTapOculto,
            child: ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Versión'),
              subtitle: const Text('v1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
