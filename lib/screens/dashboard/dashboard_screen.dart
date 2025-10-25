import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/goals/goals_screen.dart';
import 'package:horizon_finance/screens/reports/reports_screen.dart';
// NÃO INCLUÍMOS fl_chart para evitar erros de dependência se não estiver no pubspec.yaml

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Simulação de dados
  final double saldoAtual = 12500.75;
  final double receitasMes = 8500.00;
  final double despesasMes = 7200.25;

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- 1. HEADER ---
            _buildHeader(primaryBlue),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 2. CARTÃO DE SALDO ATUAL E RESUMO ---
                  _buildBalanceSummaryCard(primaryBlue, secondaryColor),
                  const SizedBox(height: 25),

                  // --- 3. PROJEÇÃO DOS PRÓXIMOS 30 DIAS (Placeholder) ---
                  _buildProjectionChartCard(primaryBlue),
                  const SizedBox(height: 25),

                  // --- 4. METAS EM ANDAMENTO ---
                  _buildGoalsSection(primaryBlue),
                  const SizedBox(height: 25),

                  // --- 5. ATIVIDADE RECENTE ---
                  _buildRecentActivitySection(primaryBlue),
                ],
              ),
            ),
          ],
        ),
      ),
      // Navegação inferior
      bottomNavigationBar: _buildBottomNavBar(context, primaryBlue),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Abrir modal de Nova Transação
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeader(Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo ao Horizons Finance!',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242)),
              ),
              SizedBox(height: 5),
              Text(
                'Boa noite, Usuário!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.waving_hand_outlined, color: primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummaryCard(Color primaryBlue, Color secondaryColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saldo Atual',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 5),
            Text(
              'R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseItem(
                  label: 'Receitas',
                  amount: receitasMes,
                  color: const Color(0xFF2E7D32),
                ),
                _buildIncomeExpenseItem(
                  label: 'Despesas',
                  amount: despesasMes,
                  color: const Color(0xFFE53935),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseItem(
      {required String label, required double amount, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectionChartCard(Color primaryBlue) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Projeção dos Próximos 30 Dias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryBlue.withOpacity(0.3)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'GRÁFICO DE PROJEÇÃO (FL_CHART AQUI)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection(Color primaryBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metas em Andamento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 10),
        _buildGoalProgress('Reserva de Emergência', 0.65, primaryBlue),
        _buildGoalProgress('Carro Novo', 0.20, primaryBlue),
      ],
    );
  }

  Widget _buildGoalProgress(String name, double progress, Color primaryBlue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 14)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: primaryBlue,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(Color primaryBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atividade Recente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 10),
        _buildRecentTransaction('Salário', '+ R\$ 5.000,00', true),
        _buildRecentTransaction('Aluguel', '- R\$ 1.500,00', false),
      ],
    );
  }

  Widget _buildRecentTransaction(
      String category, String amount, bool isIncome) {
    final Color statusColor =
        isIncome ? const Color(0xFF2E7D32) : const Color(0xFFE53935);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(
          isIncome ? Icons.trending_up : Icons.trending_down,
          color: statusColor,
        ),
      ),
      title:
          Text(category, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: const Text('Hoje'),
      trailing: Text(
        amount,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildBottomNavBar(BuildContext context, Color primaryBlue) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 1. DASHBOARD
          IconButton(
              icon: Icon(Icons.dashboard, color: primaryBlue),
              onPressed: () {}),

          // 2. RELATÓRIOS
          IconButton(
              icon: const Icon(Icons.list_alt, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReportsScreen()));
              }),

          const SizedBox(width: 40), // Espaço para o FAB

          // 3. METAS
          IconButton(
              icon: const Icon(Icons.track_changes, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GoalsScreen()));
              }),

          // 4. PERFIL
          IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: () {
                // TODO: Navegar para Perfil
              }),
        ],
      ),
    );
  }
}
