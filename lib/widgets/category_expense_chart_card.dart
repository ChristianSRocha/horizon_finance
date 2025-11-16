import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../features/categoryExpense/provider/report_provider.dart';

class ExpenseChartCard extends ConsumerWidget {
  const ExpenseChartCard({super.key});

  // Cores variadas para as categorias
  final List<Color> _chartColors = const [
    Color(0xFF0293ee),
    Color(0xFFf8b250),
    Color(0xFF845bef),
    Color(0xFF13d38e),
    Color(0xFFff6384),
    Color(0xFF36a2eb),
    Color(0xFFffce56),
    Color(0xFF4bc0c0),
    Color(0xFF9966ff),
    Color(0xFFff9f40),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryChartControllerProvider);

    if (state.isLoading) {
      return Card(
        elevation: 3,
        margin: const EdgeInsets.all(12),
        child: Container(
          height: 400,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return Card(
        elevation: 3,
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                "Erro: ${state.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final categories = state.data;

    if (categories.isEmpty) {
      return Card(
        elevation: 3,
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.pie_chart_outline, 
                   size: 64, 
                   color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "Nenhuma despesa no período selecionado",
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Calcular total para percentuais
    final total = categories.fold<double>(
      0.0, 
      (sum, cat) => sum + cat.totalAmount,
    );

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Despesas por Categoria",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: R\$ ${total.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            
            // Gráfico de Pizza
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: _buildPieChartSections(categories, total),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Adicionar interatividade se necessário
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            
            // Legenda
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final percentage = (category.totalAmount / total * 100);
                
                return _buildLegendItem(
                  color: _chartColors[index % _chartColors.length],
                  name: category.category,
                  value: category.totalAmount,
                  percentage: percentage,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    List<dynamic> categories,
    double total,
  ) {
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final percentage = (category.totalAmount / total * 100);
      
      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: category.totalAmount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem({
    required Color color,
    required String name,
    required double value,
    required double percentage,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'R\$ ${value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}