// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/features/ai_insights/provider/gemini_api_key_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:horizon_finance/screens/profile/settings_screen.dart';
import 'package:horizon_finance/core/services/app_initializer.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega o arquivo .env
  await dotenv.load(fileName: ".env");

  // Inicializa o Supabase com variáveis do .env
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

class AuthHandler extends ConsumerStatefulWidget {
  const AuthHandler({super.key});

  @override
  ConsumerState<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends ConsumerState<AuthHandler> {
  late final StreamSubscription<AuthState> _authSubscription;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    
    _initializeApp();
    
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final event = data.event;

      print('Auth event: $event, session: $session');

      if (event == AuthChangeEvent.passwordRecovery) {
        print('Navigating to /password-reset');
        context.go('/password-reset');
      } else if (session != null) {
        print('Navigating to /dashboard');
        context.go('/dashboard');
      } else {
        print('Navigating to /login');
        context.go('/login');
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final appInitializer = ref.read(appInitializerProvider);
      await appInitializer.initialize();
      
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      print('Erro ao inicializar app: $e');

      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }
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
