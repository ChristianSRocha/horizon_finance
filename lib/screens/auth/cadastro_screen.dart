import 'package:flutter/material.dart';
import 'horizon_finance/screens/auth/renda_mensal_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RendaMensalScreen()),
        );
      }
    } else {
      _showSnackBar('Corrija os erros do formulário para continuar.');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;
    const Color cardColor = Colors.white;

    return Scaffold(
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
                    Text(
                      'Criar Sua Conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Seja bem-vindo ao Horizons Finance!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 35),

                    _buildLabel('E-mail'),
                    _buildEmailInputField(primaryGreen, _emailController),
                    const SizedBox(height: 20),

                    _buildLabel('Senha'),
                    _buildPasswordInputField('•••••••••', primaryGreen, _passwordController),
                    const SizedBox(height: 20),

                    _buildLabel('Confirmar Senha'),
                    _buildConfirmPasswordInputField('•••••••••', primaryGreen, _confirmPasswordController, _passwordController),
                    const SizedBox(height: 30),

                    _buildPrimaryButton(
                      text: _isLoading ? 'Cadastrando...' : 'Criar Conta',
                      color: primaryGreen,
                      textColor: Colors.white,
                      onPressed: _isLoading ? null : _handleCadastro,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      'Já tem uma conta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    _buildSecondaryButton(
                      text: 'Fazer Login',
                      borderColor: primaryGreen.withOpacity(0.5),
                      textColor: primaryGreen.withOpacity(0.9),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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

  Widget _buildEmailInputField(Color iconColor, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'O e-mail é obrigatório.';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Insira um e-mail válido.';
        }
        return null;
      },
      decoration: _inputDecoration(
        hintText: 'seu@email.com',
        icon: Icons.email_outlined,
        iconColor: iconColor,
      ),
    );
  }

  Widget _buildPasswordInputField(String hintText, Color iconColor, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'A senha é obrigatória.';
        }
        if (value.length < 6) {
          return 'A senha deve ter pelo menos 6 caracteres.';
        }
        return null;
      },
      decoration: _inputDecoration(
        hintText: hintText,
        icon: Icons.lock_outline,
        iconColor: iconColor,
      ),
    );
  }

  Widget _buildConfirmPasswordInputField(
      String hintText,
      Color iconColor,
      TextEditingController controller,
      TextEditingController passwordController,
      ) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirme sua senha.';
        }
        if (value != passwordController.text) {
          return 'As senhas não coincidem!';
        }
        return null;
      },
      decoration: _inputDecoration(
        hintText: hintText,
        icon: Icons.lock_outline,
        iconColor: iconColor,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, required IconData icon, required Color iconColor}) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: iconColor.withOpacity(0.7), size: 18),
      filled: true,
      fillColor: Colors.white,
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

  Widget _buildSecondaryButton({
    required String text,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}