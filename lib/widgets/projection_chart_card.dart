import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/projectionPoint/providers/projection_provider.dart';
import 'package:intl/intl.dart';

class ProjectionChartCard extends ConsumerStatefulWidget {
  const ProjectionChartCard({super.key});

  @override
  ConsumerState<ProjectionChartCard> createState() => _ProjectionChartCardState();
}

class _ProjectionChartCardState extends ConsumerState<ProjectionChartCard> {
  @override
  void initState() {
    super.initState();
    // Carrega a projeção ao inicializar
    Future.microtask(() => ref.read(projectionProvider.notifier).loadProjection());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectionProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Projeção de Saldo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Próximos 90 dias',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: state.isLoading
                      ? null
                      : () => ref.read(projectionProvider.notifier).loadProjection(),
                  tooltip: 'Atualizar projeção',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Conteúdo
            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.errorMessage != null)
              _buildErrorState(state.errorMessage!)
            else if (state.points.isEmpty)
              _buildEmptyState()
            else
              _buildChartContent(state, currencyFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar projeção',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.analytics_outlined, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Sem dados suficientes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione transações para ver a projeção',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent(state, NumberFormat currencyFormat) {
    final firstBalance = state.points.first.balance;
    final lastBalance = state.points.last.balance;
    final variation = lastBalance - firstBalance;
    final variationPercent = firstBalance != 0 
        ? (variation / firstBalance * 100) 
        : 0.0;

    return Column(
      children: [
       // Indicador principal centralizado
        Center(
          child: _buildMainIndicator(
            value: currencyFormat.format(lastBalance),
            color: lastBalance < 0 ? Colors.red : Colors.green,
            icon: lastBalance < 0 ? Icons.trending_down : Icons.trending_up,),
      ),

        const SizedBox(height: 8),
        Center(
          child: Text(
            'Saldo atual: ${currencyFormat.format(firstBalance)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Alerta se o saldo ficar negativo
        if (lastBalance < 0)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Atenção: Sua projeção indica saldo negativo em ${_calculateDaysUntilZero(state.points)} dias',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seu saldo permanecerá positivo nos próximos 90 dias',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // Gráfico
        SizedBox(
          height: 280,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _calculateInterval(state.points),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: value == 0 ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                    strokeWidth: value == 0 ? 1.5 : 1,
                    dashArray: value == 0 ? [5, 5] : null,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 15,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= state.points.length) return const SizedBox();
                      final date = state.points[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    },
                  ),
                ),
               leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1000, // força espaçamento numérico igual
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      final short = NumberFormat.compact(locale: 'pt_BR').format(value);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          short,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      );
                    },
                  ),
                ),

                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              minY: _calculateMinY(state.points),
              maxY: _calculateMaxY(state.points),
              lineBarsData: [
                LineChartBarData(
                  spots: state.points
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.balance))
                      .toList()
                      .cast<FlSpot>(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      if (index % 15 == 0 || index == 0 || index == state.points.length - 1) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      }
                      return FlDotCirclePainter(radius: 0, color: Colors.transparent);
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.blue.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey.withOpacity(0.9),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final date = state.points[spot.x.toInt()].date;
                      return LineTooltipItem(
                        '${DateFormat('dd/MM/yyyy').format(date)}\n${currencyFormat.format(spot.y)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIndicator({
  required String value,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo projetado em 90 dias',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  int _calculateDaysUntilZero(List points) {
    for (int i = 0; i < points.length; i++) {
      if (points[i].balance < 0) {
        return i;
      }
    }
    return 90;
  }

  double _calculateMinY(List points) {
    final minBalance = points.map((p) => p.balance).reduce((a, b) => a < b ? a : b);
    return minBalance - (minBalance.abs() * 0.1);
  }

  double _calculateMaxY(List points) {
    final maxBalance = points.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
    return maxBalance + (maxBalance.abs() * 0.1);
  }

  double _calculateInterval(List points) {
    final minBalance = points.map((p) => p.balance).reduce((a, b) => a < b ? a : b);
    final maxBalance = points.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
    final range = maxBalance - minBalance;
    
    if (range < 1000) return 200;
    if (range < 5000) return 1000;
    if (range < 10000) return 2000;
    return 5000;
  }

  String _formatCompact(double value) {
  if (value.abs() >= 1000000) {
    return "R\$ ${(value / 1000000).toStringAsFixed(1)} mi";
  }
  if (value.abs() >= 1000) {
    return "R\$ ${(value / 1000).toStringAsFixed(1)} mil";
  }
  return "R\$ ${value.toStringAsFixed(0)}";
}

}