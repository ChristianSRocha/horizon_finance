import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';

void main() {
  runApp(const HorizonsFinanceApp());
}

class HorizonsFinanceApp extends StatelessWidget {
  const HorizonsFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF46A582);
    const Color softBeige = Color(0xFFE9E0C1);

    return MaterialApp(
      title: 'Horizons Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: softBeige,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
        ),
        useMaterial3: true,
      ),
      home: const LoginCadastroScreen(),
    );
  }
}