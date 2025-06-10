import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/widgets/widgets.dart';
import 'package:lilium_app/theme/theme.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});
  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  late SharedPreferences _prefs;
  bool _loading = true;

  List<String> contactos = ["", ""];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < contactos.length; i++) {
        contactos[i] = _prefs.getString('contacto_$i') ?? "";
      }
      _loading = false;
    });
  }

  Future<void> _editarContacto(int index) async {
    final TextEditingController controller = TextEditingController(
      text: contactos[index],
    );

    final nuevoContacto = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar número de contacto'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Número',
              hintText: 'Ingresa nuevo número',
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

    if (nuevoContacto != null) {
      setState(() {
        contactos[index] = nuevoContacto;
      });
      await _prefs.setString('contacto_$index', nuevoContacto);
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
      resizeToAvoidBottomInset: true,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: Colors.black.withValues(),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(contactos.length, (index) {
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
                                  color: Colors.black.withValues(),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              contactos[index],
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainAppScreen(),
                    ),
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
