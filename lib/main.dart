import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const IskoLaterApp());
}

class IskoLaterApp extends StatelessWidget {
  const IskoLaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsKO-LATER',
      theme: ThemeData(
        colorSchemeSeed: Colors.brown,
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}