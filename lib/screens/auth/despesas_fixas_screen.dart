import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';

class DespesasFixasScreen extends ConsumerStatefulWidget {
  const DespesasFixasScreen({super.key});

  @override
  ConsumerState<DespesasFixasScreen> createState() => _DespesasFixasScreenState();
}

class _DespesasFixasScreenState extends ConsumerState<DespesasFixasScreen> {
  final List<Map<String, dynamic>> _despesas = [
    {
      'name': 'Aluguel/Hipoteca',
      'icon': Icons.home_outlined,
      'value': 0.0,
      'controller': TextEditingController(),
    },
    {
      'name': 'Assinaturas',
      'icon': Icons.subscriptions_outlined,
      'value': 0.0,
      'controller': TextEditingController(),
    },
    {
      'name': 'Plano de Saúde',
      'icon': Icons.local_hospital_outlined,
      'value': 0.0,
      'controller': TextEditingController(),
    },
    {
      'name': 'Mensalidades',
      'icon': Icons.school_outlined,
      'value': 0.0,
      'controller': TextEditingController(),
    },
    {
      'name': 'Outras Despesas Fixas',
      'icon': Icons.more_horiz,
      'value': 0.0,
      'controller': TextEditingController(),
    },
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    // Libera os controllers
    for (var despesa in _despesas) {
      (despesa['controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  // Converte string formatada para double
  double _parseValue(String text) {
    if (text.isEmpty) return 0.0;
    
    // Remove R$, espaços e converte , para .
    String cleanValue = text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '') // Remove separador de milhar
        .replaceAll(',', '.'); // Converte decimal
    
    return double.tryParse(cleanValue) ?? 0.0;
  }

  // Formata valor para exibição
  String _formatValue(String text) {
    if (text.isEmpty) return '';
    
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanText.isEmpty) return '';
    
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

    return '$integerPart,$fractionalPart';
  }

  // Salva todas as despesas no backend
  Future<void> _saveAndContinue() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final transactionService = ref.read(TransactionServiceProvider);
      
      // Lista para armazenar apenas despesas com valor > 0
      List<Map<String, dynamic>> despesasParaSalvar = [];

      // Processa cada despesa
      for (var despesa in _despesas) {
        final controller = despesa['controller'] as TextEditingController;
        final valor = _parseValue(controller.text);
        


        // Só adiciona se valor > 0
        if (valor > 0) {
          despesasParaSalvar.add({
            'descricao': despesa['name'],
            'valor': valor,
          });
          
        } 
      }


      // Salva cada despesa no banco
      int savedCount = 0;
      for (var despesa in despesasParaSalvar) {
        try {

          final transaction = await transactionService.addTransaction(
            descricao: despesa['descricao'],
            tipo: TransactionType.despesa,
            valor: despesa['valor'],
            categoriaId: 1, // Ajuste conforme sua lógica de categorias
            fixedTransaction: true,
            diaDoMes: 5, // Dia padrão, ajuste conforme necessário
            data: null,
          );

          savedCount++;
          
        } catch (e) {
          // Loga o erro para diagnóstico, mas permite que o loop continue
          developer.log('Falha ao salvar a despesa "${despesa['descricao']}"', error: e);
          // Continue tentando salvar as outras despesas
        }
      }


      if (mounted) {
        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$savedCount despesa(s) salva(s) com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Pequeno delay para mostrar o snackbar
        await Future.delayed(const Duration(milliseconds: 500));

        // Marca o onboarding como concluído
        await ref.read(authServiceProvider.notifier).concluirOnboarding();

        // Navega para o dashboard usando go_router
        context.go('/dashboard');
      }
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar despesas: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 10),
          
          Text(
            'Quais são suas despesas fixas?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Insira 0,00 nas despesas que você não possui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              itemCount: _despesas.length,
              itemBuilder: (context, index) {
                final despesa = _despesas[index];
                return _buildDespesaTile(
                  name: despesa['name'],
                  icon: despesa['icon'],
                  controller: despesa['controller'],
                  primaryColor: primaryBlue,
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20, top: 10),
            child: ElevatedButton(
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
                      'Finalizar e Acessar o App',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDespesaTile({
    required String name,
    required IconData icon,
    required TextEditingController controller,
    required Color primaryColor,
  }) {
    final TextStyle valueStyle = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),

            SizedBox(
              width: 120, 
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                onChanged: (value) {
                  // Formata o valor enquanto digita
                  String formatted = _formatValue(value);
                  if (formatted.isNotEmpty) {
                    controller.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                  
  
                },
                style: valueStyle, 
                decoration: InputDecoration(
                  prefixText: 'R\$ ', 
                  prefixStyle: valueStyle, 
                  hintText: '0,00',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  isDense: true, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}