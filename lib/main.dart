import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/features/ai_insights/provider/gemini_api_key_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:horizon_finance/screens/profile/settings_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Carrega o arquivo .env
  await dotenv.load(fileName: ".env");

  // 2️⃣ Inicializa o Supabase com variáveis do .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    ProviderScope(
      overrides: [
        geminiApiKeyProvider.overrideWithValue(
          dotenv.env['GEMINI_API_KEY']!,
        ),
      ],
      child: const HorizonsFinanceApp(),
    ),
  );
}

class HorizonsFinanceApp extends ConsumerWidget {
  const HorizonsFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryBlue = Color(0xFF0D47A1);
    
    // Observa o provider do tema da settings_screen
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Horizons Finance',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: primaryBlue),
          titleTextStyle: TextStyle(
            color: primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: const Color(0xFF1976D2),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        dialogBackgroundColor: const Color(0xFF1E1E1E),
      ),
      themeMode: themeMode,
    );
  }
}

class AuthHandler extends StatefulWidget {
  const AuthHandler({super.key});

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final event = data.event;
      log('Auth event: $event, session: $session');
      if (event == AuthChangeEvent.passwordRecovery) {
        log('Navigating to /password-reset');
        context.go('/password-reset');
      } else if (session != null) {
        log('Navigating to /dashboard');
        context.go('/dashboard');
      } else {
        log('Navigating to /login');
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}