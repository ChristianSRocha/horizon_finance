import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';

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
  final Color _color = const Color(0xFFE53935);

  int _selectedDay = DateTime.now().day;
  int _selectedCategoryId = 6;
  String _selectedCategoryName = 'Aluguel/Moradia';

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

  Future<void> _saveTransaction() async {
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

    setState(() => _isLoading = true);

    try {
      final transactionService = ref.read(TransactionServiceProvider);

      final descricao = _descriptionController.text.trim().isEmpty
          ? _expenseCategories[_selectedCategoryId]!
          : _descriptionController.text.trim();

      print(
        'Salvando despesa fixa (TEMPLATE) - Valor: R\$ ${valor.toStringAsFixed(2)}, Dia: $_selectedDay',
      );

      await transactionService.addTransaction(
        descricao: descricao,
        tipo: TransactionType.despesa,
        valor: valor,
        categoriaId: _selectedCategoryId,
        fixedTransaction: true,
        diaDoMes: _selectedDay,
      );

      if (mounted) {
        _valueController.clear();
        _descriptionController.clear();

        setState(() {
          _selectedCategoryName = 'Aluguel/Moradia';
          _selectedCategoryId = 6;
          _selectedDay = DateTime.now().day;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Template "$descricao" criado com sucesso! (Dia $_selectedDay)',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on Exception catch (e) {
      print(
        'Erro ao salvar despesa fixa: ${e.toString()}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(
        'Erro inesperado: ${e.toString()}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro inesperado ao salvar. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);

    try {
      print(
        'Finalizando onboarding...',
      );

      await ref.read(authServiceProvider.notifier).concluirOnboarding();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Onboarding concluído! Templates cadastrados com sucesso.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          context.go('/dashboard');
        }
      }
    } on Exception catch (e) {
      print(
        'Erro ao finalizar onboarding: ${e.toString()}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(
        'Erro inesperado ao finalizar: ${e.toString()}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Erro ao finalizar Onboarding. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDay(BuildContext context) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Selecione o dia do mês'),
          children: List.generate(31, (index) {
            final day = index + 1;
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, day),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Dia $day',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        day == _selectedDay ? FontWeight.bold : FontWeight.normal,
                    color:
                        day == _selectedDay ? _color : Colors.black87,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDay = picked);
    }
  }

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
        final parsedValue = _parseValue(value ?? '');
        if (parsedValue <= 0) {
          return 'Insira um valor maior que zero.';
        }
        return null;
      },
    );
  }

  Widget _buildDayField(Color color) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: 'Dia $_selectedDay de cada mês'),
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
      onTap: () => _selectDay(context),
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
        labelText: 'Descrição (Opcional)',
        hintText: 'Ex: Assinatura Netflix',
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
                  'Cadastre templates de despesas que se repetem todo mês.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                _buildValueField(_color),
                const SizedBox(height: 20),

                _buildDayField(_color),
                const SizedBox(height: 20),

                _buildCategoryField(_color),
                const SizedBox(height: 20),

                _buildDescriptionField(_color),
                const SizedBox(height: 40),

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
