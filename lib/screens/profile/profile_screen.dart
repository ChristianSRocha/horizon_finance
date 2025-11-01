import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/views/screens/reports/reports_screen.dart';
import 'package:horizon_finance/widgets/bottom_nav_bar.dart';
// imports de telas removidos pois a navegação será feita via Navigator pelo app principal
// BottomNavBar removido: usar a navegação existente do projeto principal

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: primaryBlue.withOpacity(0.1),
                  child: Icon(Icons.person, size: 56, color: primaryBlue),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Usuário Exemplo',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'usuario@exemplo.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informações',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryBlue)),
                      const SizedBox(height: 12),
                      _infoRow('Nome', 'Usuário Exemplo'),
                      const Divider(),
                      _infoRow('E-mail', 'usuario@exemplo.com'),
                      const Divider(),
                      _infoRow('Renda mensal', 'R\$ 0,00'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Apenas uma ação de UI (front-only). Sem alterar backend.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar perfil (front-only)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Editar perfil'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // Logout UI action: apenas retorna para a tela anterior
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryBlue,
                  side: BorderSide(color: primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        activeIndex: 3,
        onDashboard: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
        onList: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ReportsScreen()),
          );
        },
        onTrack: () {},
        onProfile: () {},
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
