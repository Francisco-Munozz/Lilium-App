import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contactos_screen.dart';

// para pruebas
// rut 123456789
// pin 1234

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final rut = _rutController.text.trim();
    final pin = _pinController.text.trim();

    if (rut.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos para continuar'),
        ),
      );
      return;
    }

    const pinValido = '1234';

    if (pin == pinValido) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rut_usuario', rut);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ContactosScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PIN incorrecto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bienvenido a Lilium App',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logo
                      Image.asset(
                        'assets/images/lilium_logo.png',
                        height: 120,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.image_not_supported,
                              size: 100,
                            ),
                      ),
                      const SizedBox(height: 36),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _rutController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'RUT (sin puntos ni guion)',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _pinController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'PIN de acceso',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(height: 36),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD6A5),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 6,
                                ),
                                onPressed: _login,
                                child: const Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
