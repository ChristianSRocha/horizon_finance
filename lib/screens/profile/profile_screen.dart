import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';
import 'package:horizon_finance/screens/auth/login_cadastro_screen.dart';
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 42,
              backgroundColor: primaryBlue,
              child: const Icon(Icons.person, size: 42, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text('Nome do Usuário',
                style: TextStyle(
                    fontSize: 18,
                    color: primaryBlue,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('usuario@email.com', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Perfil'),
                onTap: () {
                  // TODO: Implementar edição de perfil
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  // TODO: Navegar para configurações
                },
              ),
            ),
            Card(
  margin: const EdgeInsets.symmetric(vertical: 8),
  child: ListTile(
    leading: const Icon(Icons.logout, color: Colors.red),
    title: const Text('Sair'),
    onTap: () async {
      try {
        await ref.read(authServiceProvider.notifier).signOut();

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginCadastroScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao sair: $e')),
        );
      }
    },
  ),
), ],
        ),
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: 3,
        primaryColor: primaryBlue,
      ),
    );
  }
}