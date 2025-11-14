import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class DespesasFixasScreen extends ConsumerStatefulWidget {
  const DespesasFixasScreen({super.key});

  @override
  ConsumerState<DespesasFixasScreen> createState() =>
      _DespesasFixasScreenState();
}

class _DespesasFixasScreenState extends ConsumerState<DespesasFixasScreen> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final Color _color = const Color(0xFFE53935); // Vermelho para Despesa Fixa

  // ESTADOS
  DateTime _selectedDate = DateTime.now();
  int _selectedCategoryId = 6;
  String _selectedCategoryName = 'Aluguel/Moradia';

  // CATEGORIAS MOCK
  final Map<int, String> _expenseCategories = {
    6: 'Aluguel/Moradia',
    7: 'Contas Fixas (Luz, Água)',
    8: 'Assinaturas',
    9: 'Transporte',
    10: 'Educação',
    11: 'Saúde',
    12: 'Outros Fixos',
  };

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- FUNÇÕES DE VALOR E FORMATAÇÃO ---

  double _parseValue(String text) {
    if (text.isEmpty) return 0.0;

    String cleanValue = text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    return double.tryParse(cleanValue) ?? 0.0;
  }

  // CORREÇÃO APLICADA: Função de formatação para remover zeros à esquerda
  String _formatValue(String text) {
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanText.isEmpty) return '0,00';

    while (cleanText.length < 3) {
      cleanText = '0$cleanText';
    }

    String integerPart = cleanText.substring(0, cleanText.length - 2);
    String fractionalPart = cleanText.substring(cleanText.length - 2);

    // CORREÇÃO CHAVE: Remove zeros à esquerda (ex: "001" -> "1")
    integerPart = BigInt.parse(integerPart).toString();

    if (integerPart.length > 3) {
      integerPart = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    return '$integerPart,$fractionalPart';
  }

  // --- FUNÇÕES DE FLUXO ---

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final valor = _parseValue(_valueController.text);
    if (valor <= 0) return;

    setState(() => _isLoading = true);

    try {
      final transactionService = ref.read(TransactionServiceProvider);

      await transactionService.addTransaction(
        descricao: _descriptionController.text.isEmpty
            ? 'Despesa Fixa'
            : _descriptionController.text,
        tipo: TransactionType.despesa,
        valor: valor,
        categoriaId: _selectedCategoryId,
        fixedTransaction: true,
        diaDoMes: _selectedDate.day,
        data: _selectedDate,
      );

      if (mounted) {
        _valueController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategoryName = 'Aluguel/Moradia';
          _selectedCategoryId = 6;
          _selectedDate = DateTime.now();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Despesa "${_expenseCategories[_selectedCategoryId]}" salva! Adicione outra se necessário.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);
    try {
      // Usa o serviço para marcar que o onboarding foi concluído
      await ref.read(authServiceProvider.notifier).concluirOnboarding();
      if (mounted) context.go('/dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao finalizar Onboarding.'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- FUNÇÕES DE DATA E CATEGORIA ---

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // --- WIDGETS DE CONSTRUÇÃO ---

  Widget _buildValueField(Color color) {
    return TextFormField(
      controller: _valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        String formatted = _formatValue(value);
        if (formatted.isNotEmpty) {
          _valueController.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
      decoration: InputDecoration(
        labelText: 'Valor da Despesa',
        prefixText: 'R\$ ',
        prefixStyle: TextStyle(color: color, fontSize: 18),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
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
    );
  }

  Widget _buildDateField(Color color) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _formatDate(_selectedDate)),
      decoration: InputDecoration(
        labelText: 'Dia de Vencimento',
        prefixIcon: Icon(Icons.calendar_today, color: color),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildCategoryField(Color color) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.category, color: color),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      value: _selectedCategoryId,
      items: _expenseCategories.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCategoryId = newValue;
            _selectedCategoryName = _expenseCategories[newValue]!;
          });
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Selecione uma categoria.';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(Color color) {
    return TextFormField(
      controller: _descriptionController,
      maxLength: 100,
      decoration: InputDecoration(
        labelText: 'Descrição (Ex: Assinatura Netflix)',
        prefixIcon: Icon(Icons.info_outline, color: color),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // TÍTULOS
                Text(
                  'Despesas Fixas Recorrentes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _color,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Registre suas despesas fixas (Aluguel, Assinaturas, etc.).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // CAMPOS DE FORMULÁRIO
                _buildValueField(_color),
                const SizedBox(height: 20),

                _buildDateField(_color),
                const SizedBox(height: 20),

                _buildCategoryField(_color),
                const SizedBox(height: 20),

                _buildDescriptionField(_color),
                const SizedBox(height: 40),

                // BOTÃO PRINCIPAL: SALVA E LIMPA O FORM
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    disabledBackgroundColor: _color.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Registrar e Adicionar Outra Despesa',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 20),

                // BOTÃO SECUNDÁRIO: FINALIZA O ONBOARDING
                OutlinedButton(
                  onPressed: _isLoading ? null : _finishOnboarding,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Finalizar Onboarding',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
