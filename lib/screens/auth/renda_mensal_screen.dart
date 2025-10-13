import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';

class RendaMensalScreen extends StatefulWidget {
  const RendaMensalScreen({super.key});

  @override
  State<RendaMensalScreen> createState() => _RendaMensalScreenState();
}

class _RendaMensalScreenState extends State<RendaMensalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rendaController = TextEditingController();
  final TextEditingController _despesasFixasController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleContinuar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular processamento
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Aqui você navegaria para o dashboard principal
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Configuração Concluída!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Sua conta foi configurada com sucesso. Agora você pode começar a usar o Horizon Finance!',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _rendaController.dispose();
    _despesasFixasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryNavy = Theme.of(context).primaryColor;
    const Color cardColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuração Inicial',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryNavy,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Card(
            color: cardColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.account_balance_wallet,
                      size: 64,
                      color: primaryNavy,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Configure sua Renda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Para começar, precisamos conhecer sua situação financeira básica',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 35),

                    _buildLabel('Renda Mensal Principal'),
                    _buildMoneyInputField(
                      'R\$ 0,00',
                      primaryNavy,
                      _rendaController,
                      'Digite sua renda mensal principal',
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Despesas Fixas Mensais (opcional)'),
                    _buildMoneyInputField(
                      'R\$ 0,00',
                      primaryNavy,
                      _despesasFixasController,
                      'Aluguel, financiamentos, etc.',
                      isRequired: false,
                    ),
                    const SizedBox(height: 30),

                    _buildInfoCard(),
                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      text: _isLoading ? 'Configurando...' : 'Continuar',
                      color: primaryNavy,
                      textColor: Colors.white,
                      onPressed: _isLoading ? null : _handleContinuar,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
      ),
    );
  }

  Widget _buildMoneyInputField(
    String hintText,
    Color iconColor,
    TextEditingController controller,
    String helperText, {
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CurrencyInputFormatter(),
      ],
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo é obrigatório.';
              }
              return null;
            }
          : null,
      decoration: _inputDecoration(
        hintText: hintText,
        icon: Icons.attach_money,
        iconColor: iconColor,
        helperText: helperText,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Você pode alterar essas informações a qualquer momento nas configurações do app.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    required Color iconColor,
    String? helperText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: iconColor.withOpacity(0.7), size: 18),
      filled: true,
      fillColor: Colors.white,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: iconColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}

// Formatter para valores monetários
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove todos os caracteres não numéricos
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Converte para centavos
    int value = int.parse(cleanText);
    
    // Formata como moeda
    String formatted = (value / 100).toStringAsFixed(2);
    formatted = 'R\$ ${formatted.replaceAll('.', ',')}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
