import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:horizon_finance/features/categoryExpense/provider/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/bottom_nav_menu.dart';
import '../../features/transactions/models/transactions.dart';
import '../../features/transactions/services/transaction_service.dart';
import 'package:horizon_finance/widgets/category_expense_chart_card.dart';
import 'package:horizon_finance/features/categories/services/category_provider.dart';

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
    final now = DateTime.now();
    _dataInicio = DateTime(now.year, now.month, 1);
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

      final now = DateTime.now();
      await ref.read(categoryChartControllerProvider.notifier)
               .load(now.year, now.month);

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

  // Abre modal de edição/exclusão
  Future<void> _mostrarModalEdicao(Transaction transaction) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditTransactionModal(
        transaction: transaction,
        onSave: () async {
          await _carregarTransacoes();
        },
        onDelete: () async {
          await _carregarTransacoes();
        },
      ),
    );
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
                  _buildDateFilter(primaryBlue),
                  const SizedBox(height: 20),

                  if (_transacoesExibidas.isEmpty)
                    _buildEmptyState()
                  else ...[
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

                    ExpenseChartCard(),
                    const SizedBox(height: 20),
                    
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
          child: InkWell(
            onTap: () => _mostrarModalEdicao(t),
            borderRadius: BorderRadius.circular(12),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_formatCurrency(t.valor),
                      style: TextStyle(
                          color: isReceita ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(Icons.edit_outlined, 
                    size: 18, 
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
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


// MODAL DE EDIÇÃO/EXCLUSÃO


class _EditTransactionModal extends ConsumerStatefulWidget {
  final Transaction transaction;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const _EditTransactionModal({
    required this.transaction,
    required this.onSave,
    required this.onDelete,
  });

  @override
  ConsumerState<_EditTransactionModal> createState() =>
      _EditTransactionModalState();
}

class _EditTransactionModalState extends ConsumerState<_EditTransactionModal> {
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late DateTime _selectedDate;
  late int? _selectedCategoryId; // Correto, é anulável
  late int? _selectedDayOfMonth;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.transaction.descricao);
    _valueController = TextEditingController(
      text: _formatValueForInput(widget.transaction.valor),
    );
    _selectedDate = widget.transaction.data ?? widget.transaction.dataCriacao;
    _selectedCategoryId = widget.transaction.categoriaId;
    _selectedDayOfMonth = widget.transaction.diaDoMes;
  }

  String _formatValueForInput(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double _parseValue(String text) {
    if (text.isEmpty) return 0.0;
    String cleanValue = text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  String _formatValue(String text) {
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) return '0,00';

    while (cleanText.length < 3) {
      cleanText = '0$cleanText';
    }

    String integerPart = cleanText.substring(0, cleanText.length - 2);
    String fractionalPart = cleanText.substring(cleanText.length - 2);
    integerPart = BigInt.parse(integerPart).toString();

    if (integerPart.length > 3) {
      integerPart = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    return '$integerPart,$fractionalPart';
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    final valor = _parseValue(_valueController.text);

    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insira um valor válido maior que zero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validação para transação fixa
    if (widget.transaction.fixedTransaction && _selectedDayOfMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o dia de vencimento da transação fixa.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }


    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(TransactionServiceProvider);

      await service.updateTransaction(
        id: widget.transaction.id,
        descricao: _descriptionController.text.trim(),
        tipo: widget.transaction.tipo,
        valor: valor,
        categoriaId: _selectedCategoryId!, 
        fixedTransaction: widget.transaction.fixedTransaction,
        data: _selectedDate, // Service vai ignorar se for fixed

      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transação atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSave(); // Recarrega a lista na tela anterior
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmarExclusao() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
            'Deseja realmente excluir a transação "${widget.transaction.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await _excluirTransacao();
    }
  }

  Future<void> _excluirTransacao() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(TransactionServiceProvider);
      await service.deleteTransaction(widget.transaction.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transação excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onDelete(); // Recarrega a lista na tela anterior
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReceita = widget.transaction.tipo == TransactionType.receita;
    final color = isReceita ? Colors.green : Colors.red;

    final categoriesAsync =
        ref.watch(categoryListProvider(widget.transaction.tipo));


    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(
                      isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReceita ? 'Editar Receita' : 'Editar Despesa',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(widget.transaction.dataCriacao),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Campo Valor
              TextFormField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  String formatted = _formatValue(value);
                  if (formatted.isNotEmpty) {
                    _valueController.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  prefixStyle: TextStyle(color: color, fontSize: 18),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                ),
                validator: (value) {
                  if (_parseValue(value ?? '') <= 0) {
                    return 'Insira um valor maior que zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Descrição
              TextFormField(
                controller: _descriptionController,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description_outlined, color: color),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A descrição é obrigatória.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              categoriesAsync.when(
                data: (categories) {
                  // Verifica se a categoria selecionada ainda existe na lista
                  // (pode ter sido apagada ou ser de outro tipo)
                  final bool selectionIsValid = categories
                      .any((c) => c.id == _selectedCategoryId);

                  return DropdownButtonFormField<int>(
                    value: selectionIsValid ? _selectedCategoryId : null,
                    items: categories
                        .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.nome),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: Icon(Icons.category_outlined, color: color),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? 'Selecione uma categoria.' : null,
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Erro ao carregar categorias: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              // ---------------------

              const SizedBox(height: 16),

              // Campo de Data (Condicional)
              if (widget.transaction.fixedTransaction)
                // SE FOR TRANSAÇÃO FIXA
                DropdownButtonFormField<int>(
                  value: _selectedDayOfMonth,
                  items: List.generate(
                    31,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('Todo dia ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => _selectedDayOfMonth = value),
                  decoration: InputDecoration(
                    labelText: 'Dia do Vencimento',
                    prefixIcon:
                        Icon(Icons.calendar_month_outlined, color: color),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: color, width: 2),
                    ),
                  ),
                  validator: (value) =>
                      value == null ? 'Selecione o dia.' : null,
                )
              else
                // SE FOR TRANSAÇÃO NORMAL
                InkWell(
                  onTap: _selecionarData,
                  borderRadius: BorderRadius.circular(10),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.date_range_outlined, color: color),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Botões de Ação
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    // Botão Excluir
                    Expanded(
                      flex: 1,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Excluir'),
                        onPressed: _confirmarExclusao,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botão Salvar
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt_outlined),
                        label: const Text('Salvar Alterações'),
                        onPressed: _salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}