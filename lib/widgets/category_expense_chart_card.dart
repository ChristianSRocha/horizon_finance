import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../features/categoryExpense/provider/report_provider.dart';

class ExpenseChartCard extends ConsumerStatefulWidget {
  const ExpenseChartCard({super.key});

  @override
  ConsumerState<ExpenseChartCard> createState() => _ExpenseChartCardState();
}

class _ExpenseChartCardState extends ConsumerState<ExpenseChartCard> {
  int touchedIndex = -1;

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
  Widget build(BuildContext context) {
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
            
            // Gráfico de Pizza Interativo
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: _buildPieChartSections(categories, total),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
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
                  isHighlighted: index == touchedIndex,
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
      final isTouched = index == touchedIndex;
      
      // Valores para animação
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 95.0 : 80.0;
      final shadows = isTouched 
          ? [
              const Shadow(
                color: Colors.black45,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ]
          : [
              const Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ];
      
      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: category.totalAmount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem({
    required Color color,
    required String name,
    required double value,
    required double percentage,
    required bool isHighlighted,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                  color: isHighlighted ? Colors.black : Colors.black87,
                ),
              ),
              Text(
                'R\$ ${value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: isHighlighted ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}