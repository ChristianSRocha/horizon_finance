import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/app_router.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/screens/auth/password_reset_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qtneqexgrvkfcqtgypyl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0bmVxZXhncnZrZmNxdGd5cHlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4NzgzNTIsImV4cCI6MjA3NjQ1NDM1Mn0.WwsUCPjKoyRuKeweYSIXoWvjlxwEvSuR3hBQEpdw7k4',
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

    return MaterialApp.router(
      title: 'Horizons Finance',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: const Color(0xFF1976D2),
        ),
        scaffoldBackgroundColor: softWhite,
        useMaterial3: true,
      ),
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
