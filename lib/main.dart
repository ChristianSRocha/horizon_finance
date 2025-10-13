import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/theme/responsive_theme.dart';

void main() {
  runApp(const HorizonsFinanceApp());
}

class HorizonsFinanceApp extends StatelessWidget {
  const HorizonsFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de cores profissional para aplicativo financeiro
    const Color primaryNavy = Color(0xFF1E3A8A); // Azul navy - confiança e estabilidade
    const Color secondaryBlue = Color(0xFF3B82F6); // Azul médio - ação e confiança
    const Color accentGold = Color(0xFFD97706); // Dourado - premium e valor
    const Color successGreen = Color(0xFF059669); // Verde - crescimento e lucro
    const Color errorRed = Color(0xFFDC2626); // Vermelho - atenção e perda
    const Color neutralGray = Color(0xFFF8FAFC); // Cinza claro - fundo neutro
    const Color textDark = Color(0xFF1F2937); // Cinza escuro - texto principal

    return MaterialApp(
      title: 'Horizons Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryNavy,
        scaffoldBackgroundColor: neutralGray,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryNavy,
          primary: primaryNavy,
          secondary: secondaryBlue,
          surface: Colors.white,
          background: neutralGray,
          error: errorRed,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryNavy,
            foregroundColor: Colors.white,
            elevation: 2,
            minimumSize: const Size(0, 48), // Altura mínima para touch
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: const LoginCadastroScreen(),
    );
  }
}