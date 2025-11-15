import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/bottom_nav_menu.dart';
import '../../features/transactions/models/transactions.dart';
import '../../features/transactions/services/transaction_service.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _showAvg = false;
  bool _isLoading = false;
  
  List<Transaction> _transacoesExibidas = [];

  @override
  void initState() {
    super.initState();
    // Inicializa com o mês atual
    final now = DateTime.now();
    _dataInicio = DateTime(now.year, now.month, 1);
    // Garante que a data final não seja no futuro
    final ultimoDiaDoMes = DateTime(now.year, now.month + 1, 0);
    _dataFim = ultimoDiaDoMes.isAfter(now) ? now : ultimoDiaDoMes;
    _carregarTransacoes();
  }

  Future<void> _carregarTransacoes() async {
    if (_dataInicio == null || _dataFim == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(TransactionServiceProvider);
      final transactions = await service.getTransactionsByPeriod(
        dataInicio: _dataInicio!,
        dataFim: _dataFim!,
      );

      setState(() {
        _transacoesExibidas = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _transacoesExibidas = [];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar transações: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<FlSpot> _gerarSpots() {
    if (_transacoesExibidas.isEmpty) return [const FlSpot(0, 0)];

    final sorted = [..._transacoesExibidas]
      ..sort((a, b) => a.dataCriacao.compareTo(b.dataCriacao));

    double acumulado = 0;
    List<FlSpot> spots = [];

    for (int i = 0; i < sorted.length; i++) {
      final t = sorted[i];
      acumulado += t.tipo == TransactionType.despesa ? -t.valor : t.valor;
      spots.add(FlSpot(i.toDouble(), acumulado));
    }

    return spots;
  }

  List<String> _gerarLabelsX() {
    if (_transacoesExibidas.isEmpty) return [''];

    final sorted = [..._transacoesExibidas]
      ..sort((a, b) => a.dataCriacao.compareTo(b.dataCriacao));
    return sorted
        .map((t) => DateFormat('dd/MM').format(t.dataCriacao))
        .toList();
  }

  Future<void> _selecionarPeriodo() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dataInicio != null && _dataFim != null
          ? DateTimeRange(start: _dataInicio!, end: _dataFim!)
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 30)),
              end: DateTime.now(),
            ),
    );

    if (picked != null) {
      setState(() {
        _dataInicio = picked.start;
        _dataFim = picked.end;
      });
      
      // Recarrega as transações com o novo período
      _carregarTransacoes();
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return 'Selecionar período';
    return DateFormat('dd/MM/yyyy').format(data);
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  double _computeMaxY() {
    final spots = _gerarSpots();
    final max = spots.fold<double>(
        0.0, (prev, s) => s.y.abs() > prev ? s.y.abs() : prev);
    if (max <= 0) return 1.0;
    final magnitude = (max / 5).ceilToDouble();
    return magnitude * 5;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    final spots = _gerarSpots();
    final labels = _gerarLabelsX();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Relatórios e Análises',
            style:
                TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seleção de Período
                  _buildDateFilter(primaryBlue),
                  const SizedBox(height: 20),

                  // Verifica se há transações
                  if (_transacoesExibidas.isEmpty)
                    _buildEmptyState()
                  else ...[
                    // Card do Gráfico
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Saldo Acumulado',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF424242)),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _showAvg = !_showAvg),
                                  child: Text(
                                      _showAvg ? 'Média' : 'Total',
                                      style: TextStyle(color: primaryBlue)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 250,
                              child: LineChart(
                                _showAvg
                                    ? _buildAvgChart(
                                        spots, _computeMaxY(), labels)
                                    : _buildMainChart(spots, _computeMaxY(),
                                        labels, primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Resumo de Categorias
                    _buildSummaryCard(
                        'Receitas',
                        _transacoesExibidas
                            .where((t) => t.tipo == TransactionType.receita)
                            .fold(0.0, (sum, t) => sum + t.valor),
                        Colors.green,
                        primaryBlue),
                    const SizedBox(height: 10),
                    _buildSummaryCard(
                        'Despesas',
                        _transacoesExibidas
                            .where((t) => t.tipo == TransactionType.despesa)
                            .fold(0.0, (sum, t) => sum + t.valor),
                        Colors.red,
                        primaryBlue),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Lista de Transações
                    Text('Transações do Período',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildTransactionsList(primaryBlue),
                  ],
                ],
              ),
            ),
      bottomNavigationBar:
          BottomNavMenu(currentIndex: 1, primaryColor: primaryBlue),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhuma transação encontrada',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há transações no período selecionado',
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(Color primary) {
    return OutlinedButton.icon(
      onPressed: _selecionarPeriodo,
      icon: const Icon(Icons.date_range),
      label: Text(
        _dataInicio != null && _dataFim != null
            ? '${_formatarData(_dataInicio)} — ${_formatarData(_dataFim)}'
            : 'Selecionar período',
        style: TextStyle(color: primary, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        side: BorderSide(color: primary),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, double value, Color color, Color primary) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(Icons.trending_up, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(_formatCurrency(value),
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }

  Widget _buildTransactionsList(Color primary) {
    final sorted = [..._transacoesExibidas]
      ..sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final t = sorted[index];
        final isReceita = t.tipo == TransactionType.receita;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isReceita
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              child: Icon(
                  isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isReceita ? Colors.green : Colors.red),
            ),
            title: Text(t.descricao,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle:
                Text(DateFormat('dd/MM/yyyy HH:mm').format(t.dataCriacao)),
            trailing: Text(_formatCurrency(t.valor),
                style: TextStyle(
                    color: isReceita ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  LineChartData _buildMainChart(
      List<FlSpot> spots, double maxY, List<String> labels, Color primary) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black87,
          getTooltipItems: (touched) => touched
              .map((t) => LineTooltipItem('R\$ ${t.y.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white)))
              .toList(),
        ),
      ),
      gridData: FlGridData(show: true, horizontalInterval: maxY / 4),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              final step = (labels.length > 8)
                  ? (labels.length ~/ 6).clamp(1, labels.length)
                  : 1;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  (idx >= 0 && idx < labels.length && idx % step == 0)
                      ? labels[idx]
                      : '',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.grey.shade300)),
      minX: 0,
      maxX: (spots.isNotEmpty) ? spots.last.x : 1,
      minY: -maxY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
              colors: [primary.withValues(alpha: 0.9), Colors.cyan]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors: [
              primary.withValues(alpha: 0.2),
              Colors.cyan.withValues(alpha: 0.2)
            ]),
          ),
        ),
      ],
    );
  }

  LineChartData _buildAvgChart(
      List<FlSpot> spots, double maxY, List<String> labels) {
    if (spots.isEmpty) return LineChartData();

    final avg = spots.fold(0.0, (sum, s) => sum + s.y) / spots.length;
    final avgSpots =
        List.generate(spots.length, (i) => FlSpot(i.toDouble(), avg));

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(show: true, horizontalInterval: maxY / 4),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              final step = (labels.length > 8)
                  ? (labels.length ~/ 6).clamp(1, labels.length)
                  : 1;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                    (idx >= 0 && idx < labels.length && idx % step == 0)
                        ? labels[idx]
                        : '',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.grey.shade300)),
      minX: 0,
      maxX: (spots.isNotEmpty) ? spots.last.x : 1,
      minY: -maxY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: avgSpots,
          isCurved: true,
          gradient: const LinearGradient(
              colors: [Colors.orange, Colors.deepOrange]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
                colors: [Color(0x22FF9800), Color(0x22FF5722)]),
          ),
        ),
      ],
    );
  }
}