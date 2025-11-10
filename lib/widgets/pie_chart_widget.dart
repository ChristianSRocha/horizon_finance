import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Pequeno widget de PieChart para o dashboard.
/// Mostra Receitas x Despesas com interação de toque.
class DashboardPieChart extends StatefulWidget {
  final double receitas;
  final double despesas;

  const DashboardPieChart(
      {super.key, required this.receitas, required this.despesas});

  @override
  State<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.receitas + widget.despesas;
    final values = [widget.receitas, widget.despesas];
    final colors = [Colors.green.shade600, Colors.red.shade600];

    return AspectRatio(
      aspectRatio: 1.7,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIndicator(colors[0], 'Receitas', touchedIndex == 0),
              _buildIndicator(colors[1], 'Despesas', touchedIndex == 1),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, resp) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          resp == null ||
                          resp.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = resp.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: List.generate(2, (i) {
                  final isTouched = i == touchedIndex;
                  final value = values[i];
                  final percent = total > 0 ? (value / total * 100) : 0;

                  return PieChartSectionData(
                    color: colors[i],
                    value: value <= 0 ? 0.0001 : value,
                    title: '${percent.toStringAsFixed(0)}%',
                    radius: isTouched ? 60 : 50,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text, bool isActive) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
