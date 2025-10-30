import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/despesas_fixas_screen.dart';
import 'package:horizon_finance/features/transactions/fixed_transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RendaMensalScreen extends ConsumerStatefulWidget {
  const RendaMensalScreen({super.key});

  @override
  ConsumerState<RendaMensalScreen> createState() => _RendaMensalScreenState();
}

class _RendaMensalScreenState extends ConsumerState<RendaMensalScreen> {
  final TextEditingController _valorController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  String _formattedValue = '0,00';
  String _categoriaSelecionada = 'Salário';
  int _diaSelecionado = 5;

  final List<String> _categorias = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Aluguel',
    'Pensão',
    'Outros',
  ];

  void _formatAndSetAmount(String text) {
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
  }

  double _obterValorNumerico() {
    String cleanValue = _formattedValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    _valorController.addListener(() {
      _formatAndSetAmount(_valorController.text);
    });
  }

  @override
  void dispose() {
    _valorController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    final valorValido = _obterValorNumerico() > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Indicador de progresso
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProgressDot(true, primaryBlue),
                        _buildProgressLine(true, primaryBlue),
                        _buildProgressDot(true, primaryBlue),
                        _buildProgressLine(false, primaryBlue),
                        _buildProgressDot(false, primaryBlue),
                      ],
                    ),
                    const SizedBox(height: 40),

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
                    const SizedBox(height: 50),

                    // Campo de valor
                    const Text(
                      'Valor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'R\$ ',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                _formattedValue,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Opacity(
                      opacity: 0.0,
                      child: SizedBox(
                        height: 0,
                        child: TextField(
                          controller: _valorController,
                          focusNode: _focusNode,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Campo de categoria
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _categoriaSelecionada,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        prefixIcon: Icon(
                          _getIconeCategoria(_categoriaSelecionada),
                          color: primaryBlue,
                        ),
                      ),
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem(
                          value: categoria,
                          child: Text(
                            categoria,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoriaSelecionada = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    // Campo de dia do mês
                    const Text(
                      'Dia do recebimento',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: _diaSelecionado,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: primaryBlue,
                        ),
                      ),
                      items: List.generate(31, (index) => index + 1).map((dia) {
                        return DropdownMenuItem(
                          value: dia,
                          child: Text(
                            'Dia $dia',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _diaSelecionado = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Botão fixo na parte inferior
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: valorValido
                        ? () {
                            // Aqui você pode salvar os dados antes de navegar
                            final renda = RendaFixa(
                              valor: _obterValorNumerico(),
                              categoria: _categoriaSelecionada,
                              dia: _diaSelecionado,
                            );
                            
                            // TODO: Salvar a renda usando o service
                            // ref.read(fixedTransactionServiceProvider).saveRenda(renda);
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DespesasFixasScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[500],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Continuar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DespesasFixasScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Pular esta etapa',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDot(bool isActive, Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : Colors.grey[300],
      ),
    );
  }

  Widget _buildProgressLine(bool isActive, Color color) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isActive ? color : Colors.grey[300],
    );
  }

  IconData _getIconeCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'salário':
        return Icons.work;
      case 'freelance':
        return Icons.laptop;
      case 'investimentos':
        return Icons.trending_up;
      case 'aluguel':
        return Icons.home;
      case 'pensão':
        return Icons.account_balance;
      case 'outros':
        return Icons.attach_money;
      default:
        return Icons.monetization_on;
    }
  }
}

class RendaFixa {
  final double valor;
  final String categoria;
  final int dia;

  RendaFixa({
    required this.valor,
    required this.categoria,
    required this.dia,
  });
}