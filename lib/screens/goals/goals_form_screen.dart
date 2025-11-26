import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/models/financial_goal.dart';

class GoalFormScreen extends StatefulWidget {
  const GoalFormScreen({super.key});

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

 
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 365));
  GoalType _selectedGoalType = GoalType.savings; 
  
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

  
  
  void _saveGoal() {
    if (!_formKey.currentState!.validate()) return;
    
    final valor = _parseValue(_amountController.text);
    if (valor <= 0) return;

    
    final newGoal = FinancialGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      userId: '', 
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      targetAmount: valor,
      currentAmount: 0.0, 
      targetDate: _selectedDate,
      type: _selectedGoalType,
      status: GoalStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    
    print("META PRONTA PARA ENVIO: ${newGoal.toJson()}");

    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meta criada! (Integração pendente)')),
    );
    context.pop(); 
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
             
              DropdownButtonFormField<GoalType>(
                value: _selectedGoalType,
                decoration: _inputDecoration('Tipo de Meta', Icons.flag_outlined),
                items: GoalType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getGoalTypeName(type)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedGoalType = val!),
              ),
              const SizedBox(height: 20),

              
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

  String _getGoalTypeName(GoalType type) {
    switch (type) {
      case GoalType.savings: return 'Poupança';
      case GoalType.debt: return 'Quitar Dívidas';
      case GoalType.investment: return 'Investimento';
      case GoalType.emergency: return 'Reserva de Emergência';
      case GoalType.other: return 'Outro';
    }
  }
}