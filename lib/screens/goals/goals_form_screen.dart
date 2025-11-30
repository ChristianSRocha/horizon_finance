import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/metas/controllers/metas_controller.dart';
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({super.key});

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 365));

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double _parseValue(String text) {
    if (text.isEmpty) return 0.0;
    String cleanValue = text
        .replaceAll(RegExp(r'[^\d,\.]'), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  String _formatCurrency(String text) {
    if (text.isEmpty) return '';
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) return '';

    double value = double.parse(cleanText) / 100;
    return NumberFormat.currency(locale: 'pt_BR', symbol: '')
        .format(value)
        .trim();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        final Color primary = Theme.of(context).primaryColor;
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    final valor = _parseValue(_amountController.text);
    if (valor <= 0) return;

    // Chamada simplificada sem 'type'
    await ref.read(metasControllerProvider.notifier).adicionarMeta(
          nome: _nameController.text.trim(),
          valorTotal: valor,
          dataFinal: _selectedDate,
          descricao: _descriptionController.text.trim(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta salva com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Nova Meta',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // Não exibir o botão de voltar (leading) nesta tela
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: primaryBlue),
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: 3,
        primaryColor: primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Detalhes da Meta',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Nome da Meta',
                        Icons.label_important_outline, primaryBlue),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe um nome.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                        'Valor Alvo (R\$)', Icons.attach_money, primaryBlue),
                    onChanged: (v) {
                      final formatted = _formatCurrency(v);
                      if (formatted != v) {
                        _amountController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                    validator: (v) => (_parseValue(v ?? '') <= 0)
                        ? 'Informe um valor maior que zero.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    decoration: _inputDecoration(
                        'Data Alvo', Icons.calendar_today, primaryBlue),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration('Descrição (Opcional)',
                        Icons.description_outlined, primaryBlue),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Criar Meta',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, Color color) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: color),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 2),
      ),
    );
  }
}
