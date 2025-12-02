import 'package:flutter/material.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, AuthState;
import 'package:horizon_finance/features/transactions/models/transactions.dart';

class RendaMensalScreen extends ConsumerStatefulWidget {
  const RendaMensalScreen({super.key});

  @override
  ConsumerState<RendaMensalScreen> createState() => _RendaMensalScreenState();
}

class _RendaMensalScreenState extends ConsumerState<RendaMensalScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  String _formattedValue = '0,00';  
  bool _isLoading = false;
  bool _checking = true;
  int _selectedDay = 5;
  
  void _formatAndSetAmount(String text) {
    print('valor digitado: "$text"');

    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanText.isEmpty) {
      setState(() {
        _formattedValue = '0,00';
      });
      return;
    }

    while (cleanText.length < 3) {
      cleanText = '0$cleanText';
    }

    String integerPart = cleanText.substring(0, cleanText.length - 2);
    String fractionalPart = cleanText.substring(cleanText.length - 2);

    if (integerPart.length > 3) {
      integerPart = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }

    setState(() {
      _formattedValue = '$integerPart,$fractionalPart';
    });

    print('Valor formatado: $_formattedValue');
  }

  double _getNumericValue() {
    String cleanValue = _formattedValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  Future<void> _saveAndContinue() async {
    final valor = _getNumericValue();

    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um valor válido maior que zero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('Valor a ser salvo: R\$ ${valor.toStringAsFixed(2)}, Dia: $_selectedDay');
  
    setState(() {
      _isLoading = true;
    });
    
    try {
      final transactionService = ref.read(TransactionServiceProvider);
      
      final transaction = await transactionService.addTransaction(
        descricao: 'Renda Mensal',
        tipo: TransactionType.receita,
        valor: valor,
        categoriaId: 1,
        fixedTransaction: true,
        diaDoMes: _selectedDay,
      );

      print('Template de renda mensal criado com sucesso: ${transaction.id}');

      if (mounted) {
        context.go('/despesas-fixas');
      }
    } catch (e) {
      print('ERRO AO SALVAR: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDay(BuildContext context) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Selecione o dia de recebimento'),
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
                    fontWeight: day == _selectedDay ? FontWeight.bold : FontWeight.normal,
                    color: day == _selectedDay ? Theme.of(context).primaryColor : Colors.black87,
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

  @override
  void initState() {
    super.initState();
    _ensureEmailConfirmed();
    _controller.addListener(() {
      _formatAndSetAmount(_controller.text);
    });
  }

  Future<void> _ensureEmailConfirmed() async {
    setState(() => _checking = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      final confirmed = user?.emailConfirmedAt != null;
      if (!confirmed) {
        if (mounted) context.go('/verify-email');
        return;
      }
    } catch (_) {
      if (mounted) {
        context.go('/verify-email');
        return;
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    if (_checking) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Qual é a sua renda mensal?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Essa informação é crucial para as projeções futuras do Horizons.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => _focusNode.requestFocus(),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: primaryBlue, width: 2.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          _formattedValue,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: 'Dia $_selectedDay de cada mês'),
                decoration: InputDecoration(
                  labelText: 'Dia de Recebimento',
                  prefixIcon: Icon(Icons.calendar_today, color: primaryBlue),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryBlue, width: 2),
                  ),
                ),
                onTap: () => _selectDay(context),
              ),

              const SizedBox(height: 40),

              Opacity(
                opacity: 0.0,
                child: SizedBox(
                  height: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  disabledBackgroundColor: primaryBlue.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Continuar',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
