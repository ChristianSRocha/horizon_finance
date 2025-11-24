import 'package:go_router/go_router.dart';
import 'package:horizon_finance/screens/auth/cadastro_screen.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';
import 'package:horizon_finance/screens/auth/password_reset_screen.dart';
import 'package:horizon_finance/screens/auth/password_reset_request_screen.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/screens/auth/renda_mensal_screen.dart';
import 'package:horizon_finance/screens/auth/despesas_fixas_screen.dart';
import 'package:horizon_finance/screens/profile/edit_profile_screen.dart';
import 'package:horizon_finance/screens/reports/reports_screen.dart';
import 'package:horizon_finance/screens/goals/goals_screen.dart';
import 'package:horizon_finance/screens/profile/profile_screen.dart';
import 'package:horizon_finance/main.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthHandler(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginCadastroScreen(),
    ),
    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const CadastroScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/renda-mensal',
      builder: (context, state) => const RendaMensalScreen(),
    ),
    GoRoute(
      path: '/despesas-fixas',
      builder: (context, state) => const DespesasFixasScreen(),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: '/password-reset-request',
      builder: (context, state) => const PasswordResetRequestScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => const GoalsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
