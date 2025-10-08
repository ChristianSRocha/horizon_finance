import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/cadastro_screen.dart';

class LoginCadastroScreen extends StatelessWidget {
  const LoginCadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;
    final Color softBeige = Theme.of(context).scaffoldBackgroundColor;
    const Color cardColor = Colors.white;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Card(
            color: cardColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Horizons Finance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Seu futuro financeiro começa aqui',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 35),

                  _buildLabel('E-mail'),
                  _buildInputField(
                    'seu@email.com',
                    Icons.email_outlined,
                    false,
                    primaryGreen,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Senha'),
                  _buildInputField(
                    '•••••••••',
                    Icons.lock_outline,
                    true,
                    primaryGreen,
                  ),
                  const SizedBox(height: 30),

                  _buildPrimaryButton(
                    text: 'Entrar',
                    color: softBeige,
                    textColor: Colors.black54,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Esqueceu a senha?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Não tem uma conta?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  _buildSecondaryButton(
                    text: 'Cadastre-se',
                    borderColor: primaryGreen.withOpacity(0.5),
                    textColor: primaryGreen.withOpacity(0.9),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CadastroScreen()),
                      );
                    },
                  ),
                ],
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

  Widget _buildInputField(
      String hintText,
      IconData icon,
      bool isPassword,
      Color iconColor) {
    return TextField(
      obscureText: isPassword,
      keyboardType:
      isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
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
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
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
      child: Text(
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