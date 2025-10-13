import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/cadastro_screen.dart';
import 'package:horizon_finance/theme/responsive_theme.dart';

class LoginCadastroScreen extends StatelessWidget {
  const LoginCadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryNavy = Theme.of(context).primaryColor;
    const Color cardColor = Colors.white;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveTheme.getHorizontalPadding(context),
            vertical: ResponsiveTheme.getVerticalPadding(context),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Card(
              color: cardColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveTheme.getCardPadding(context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Horizons Finance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getTitleFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: primaryNavy,
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getSmallSpacing(context)),
                    Text(
                      'Seu futuro financeiro começa aqui',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getSubtitleFontSize(context),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getLargeSpacing(context)),

                    _buildLabel(context, 'E-mail'),
                    _buildInputField(
                      context,
                      'seu@email.com',
                      Icons.email_outlined,
                      false,
                      primaryNavy,
                    ),
                    SizedBox(height: ResponsiveTheme.getMediumSpacing(context)),

                    _buildLabel(context, 'Senha'),
                    _buildInputField(
                      context,
                      '•••••••••',
                      Icons.lock_outline,
                      true,
                      primaryNavy,
                    ),
                    SizedBox(height: ResponsiveTheme.getMediumSpacing(context)),

                    _buildPrimaryButton(
                      context,
                      text: 'Entrar',
                      color: primaryNavy,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                    SizedBox(height: ResponsiveTheme.getSmallSpacing(context)),

                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Esqueceu a senha?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: ResponsiveTheme.getSmallFontSize(context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getMediumSpacing(context)),

                    Text(
                      'Não tem uma conta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ResponsiveTheme.getSmallFontSize(context),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getSmallSpacing(context)),

                    _buildSecondaryButton(
                      context,
                      text: 'Cadastre-se',
                      borderColor: primaryNavy.withOpacity(0.5),
                      textColor: primaryNavy,
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
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveTheme.getSmallSpacing(context)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveTheme.getBodyFontSize(context),
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    String hintText,
    IconData icon,
    bool isPassword,
    Color iconColor,
  ) {
    return TextField(
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: iconColor.withOpacity(0.7),
          size: ResponsiveTheme.getIconSize(context),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: iconColor, width: 1.5),
        ),
        contentPadding: ResponsiveTheme.getInputPadding(context),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
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
        minimumSize: Size(0, ResponsiveTheme.getMinButtonHeight(context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveTheme.getBodyFontSize(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required String text,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        minimumSize: Size(0, ResponsiveTheme.getMinButtonHeight(context)),
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveTheme.getBodyFontSize(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
