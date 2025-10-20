// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Pegar no dashboard do Supabase
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Pegar no dashboard do Supabase
  );

  runApp(
    const ProviderScope(
      child: HorizonsFinanceApp(),
    ),
  );
}

class HorizonsFinanceApp extends StatelessWidget {
  const HorizonsFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);
    const Color softWhite = Color(0xFFFAFAFA);

    return MaterialApp(
      title: 'Horizons Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: const Color(0xFF1976D2),
        ),
        scaffoldBackgroundColor: softWhite,
        useMaterial3: true,
      ),
      home: const LoginCadastroScreen(),
    );
  }
}
