import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilium_app/screens/screens.dart';

// Pantalla de la fachada Habit Tracker que permite al usuario agregar un nuevo hábito (nombre del hábito y emoji)
// El usuario puede ingresar el nombre y pin secreto para acceder a la app real
class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitNameController =
      TextEditingController(); // Para el nombre del hábito
  final TextEditingController _emojiController =
      TextEditingController(); // Para el emoji

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

  Future<void> _saveHabit() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    final passwordIngresada = _emojiController.text.trim();
    final reautenticado = await reautenticarUsuario(passwordIngresada);
    final habitName = _habitNameController.text;
    final emoji = _emojiController.text;

    if (habitName == email && reautenticado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainAppScreen()),
      );
      return;
    }

    // Si no cumple la validación, sigue el flujo normal

    if (habitName.isNotEmpty && emoji.isNotEmpty) {
      Navigator.pop(context);
    } else {
      // Si los campos están vacios envia un aviso
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Completa ambos campos.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Mi nuevo Hábito',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/habit_tracker_logo.png',
              height: 50,
              color: colorScheme.surface,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ingreso del nombre del hábito
            Text(
              'Nombre del hábito',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _habitNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ej. Leer 30 mins',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Ingreso del emoji del hábito
            Text(
              'Emoji',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emojiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ej. 📖',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),

            // Botón para guardar el hábito
            ElevatedButton(
              onPressed: _saveHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Guardar Hábito',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
