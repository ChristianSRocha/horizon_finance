import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/metas/controllers/metas_controller.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({super.key});

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Opcional: mantive visualmente, mas não estamos salvando no model simplificado

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 365));
  final Color _color = const Color(0xFF0D47A1); 

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double _parseValue(String text) {
    if (text.isEmpty) return 0.0;
    String cleanValue = text.replaceAll(RegExp(r'[^\d,\.]'), '').replaceAll('.', '').replaceAll(',', '.'); 
    return double.tryParse(cleanValue) ?? 0.0;
  }

  String _formatCurrency(String text) {
    if (text.isEmpty) return '';
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) return '';
    
    double value = double.parse(cleanText) / 100;
    return NumberFormat.currency(locale: 'pt_BR', symbol: '').format(value).trim();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: _color),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Nova Meta', style: TextStyle(color: _color, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _color),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // REMOVIDO: Dropdown de GoalType
              
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nome da Meta (Ex: Carro Novo)', Icons.label_important_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe um nome.' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Valor Alvo (R\$)', Icons.attach_money),
                onChanged: (v) {
                  final formatted = _formatCurrency(v);
                  if (formatted != v) {
                    _amountController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
                validator: (v) => (_parseValue(v ?? '') <= 0) ? 'Informe um valor maior que zero.' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: DateFormat('dd/MM/yyyy').format(_selectedDate)
                ),
                decoration: _inputDecoration('Data Alvo', Icons.calendar_today),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _inputDecoration('Descrição (Opcional)', Icons.description_outlined),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Criar Meta', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _color),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _color, width: 2),
      ),
    );
  }
}