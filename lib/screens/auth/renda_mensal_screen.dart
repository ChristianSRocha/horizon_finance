import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/despesas_fixas_screen.dart';
import'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, AuthState;

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
  
  void _formatAndSetAmount(String text) {
    developer.log(
      'valor digitado: "$text"',
      name: 'RendaMensalScreen',
    );
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

    developer.log(
      'Valor formatado: $_formattedValue',
      name: 'RendaMensalScreen',
    );
  }

  // Converte o valor formatado para double
  double _getNumericValue() {
    String cleanValue = _formattedValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  // Salva a renda mensal no backend
  Future<void> _saveAndContinue() async {
    final valor = _getNumericValue();

    developer.log(
      'Valor a ser salvo: R\$ ${valor.toStringAsFixed(2)}',
      name: 'RendaMensalScreen',
    );
  
    
    setState(() {
      _isLoading = true;
    });
    
    try {

      final transactionService = ref.read(TransactionServiceProvider);
      final transaction = await transactionService.addTransactions(descricao: 'Renda Mensal', tipo: 'RECEITA', valor: valor, categoriaId: 1, fixedTransaction: true, diaDoMes: 5, data: null);

      developer.log(
        'Transação salva com sucesso: ${transaction}',
        name: 'RendaMensalScreen',
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DespesasFixasScreen(),
          ),
        );
      }
    } catch (e) {
      developer.log(
        'ERRO AO SALVAR',
        name: 'RendaMensalScreen',
        error: e.toString(),
      );

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
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _formatAndSetAmount(_controller.text);
    });
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
              const SizedBox(height: 60),
              
              GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                },
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