import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:horizon_finance/widgets/bottom_nav_bar.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/screens/profile/profile_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String _formatCurrency(double value) {
    final f = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    // Mocked data
    final double totalIncome = 8500.0;
    final double totalExpenses = 7200.25;
    final double balance = totalIncome - totalExpenses;

    final Map<String, double> expensesByCategory = {
      'Moradia': 2500,
      'Alimentação': 1500,
      'Transporte': 800,
      'Lazer': 700,
      'Outros': 700.25,
    };

    // Weekly flow (Receita vs Despesa) - mock
    final List<double> weeklyIncome = [1200, 1500, 1000, 1800];
    final List<double> weeklyExpenses = [1000, 900, 1800, 2500];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Resumo
              Row(
                children: [
                  Expanded(
                    child: _summaryCard('Receitas',
                        _formatCurrency(totalIncome), Colors.green.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard('Despesas',
                        _formatCurrency(totalExpenses), Colors.red.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard(
                        'Saldo', _formatCurrency(balance), primaryBlue),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Gráfico de despesas por categoria (pizza/rosca)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Despesas por Categoria',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  centerSpaceRadius: 40,
                                  sections: expensesByCategory.entries.map((e) {
                                    final color = _categoryColor(e.key);
                                    return PieChartSectionData(
                                      value: e.value,
                                      title:
                                          '${((e.value / expensesByCategory.values.reduce((a, b) => a + b)) * 100).toStringAsFixed(0)}%',
                                      color: color,
                                      radius: 60,
                                      titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Legend
                            SizedBox(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: expensesByCategory.entries.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 12,
                                            height: 12,
                                            color: _categoryColor(e.key)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(e.key,
                                                style: const TextStyle(
                                                    fontSize: 12))),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Comparativo de fluxo semanal (barra)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Comparativo Semanal (Receita vs Despesa)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: List.generate(4, (i) {
                              return BarChartGroupData(
                                x: i,
                                barsSpace: 6,
                                barRods: [
                                  BarChartRodData(
                                      toY: weeklyIncome[i],
                                      color: Colors.green.shade700,
                                      width: 8),
                                  BarChartRodData(
                                      toY: weeklyExpenses[i],
                                      color: Colors.red.shade700,
                                      width: 8),
                                ],
                              );
                            }),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 40)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels = [
                                      'Semana 1',
                                      'Semana 2',
                                      'Semana 3',
                                      'Semana 4'
                                    ];
                                    final index = value.toInt();
                                    if (index >= 0 && index < labels.length) {
                                      return SideTitleWidget(
                                          child: Text(labels[index],
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                          axisSide: meta.axisSide);
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        activeIndex: 1,
        onDashboard: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
        onList: () {},
        onTrack: () {},
        onProfile: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String key) {
    switch (key) {
      case 'Moradia':
        return const Color(0xFF1976D2);
      case 'Alimentação':
        return const Color(0xFF2E7D32);
      case 'Transporte':
        return const Color(0xFFF9A825);
      case 'Lazer':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }
}
