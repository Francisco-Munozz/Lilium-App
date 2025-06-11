import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lilium_app/firebase_options.dart';
import 'package:lilium_app/screens/screens.dart';
import 'package:lilium_app/screens/login_screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lilium App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _handleAuth(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _handleAuth() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Usuario autenticado: ir directo al home
      return const HomeScreen();
    } else {
      // No autenticado: ir al login
      return const LoginScreen();
    }
  }
}
