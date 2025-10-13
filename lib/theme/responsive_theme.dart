import 'package:flutter/material.dart';

class ResponsiveTheme {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Tamanhos de fonte responsivos
  static double getTitleFontSize(BuildContext context) {
    return getScreenWidth(context) * 0.07; // 7% da largura da tela
  }

  static double getSubtitleFontSize(BuildContext context) {
    return getScreenWidth(context) * 0.035; // 3.5% da largura da tela
  }

  static double getBodyFontSize(BuildContext context) {
    return getScreenWidth(context) * 0.04; // 4% da largura da tela
  }

  static double getSmallFontSize(BuildContext context) {
    return getScreenWidth(context) * 0.035; // 3.5% da largura da tela
  }

  // Espaçamentos responsivos
  static double getSmallSpacing(BuildContext context) {
    return getScreenHeight(context) * 0.01; // 1% da altura da tela
  }

  static double getMediumSpacing(BuildContext context) {
    return getScreenHeight(context) * 0.02; // 2% da altura da tela
  }

  static double getLargeSpacing(BuildContext context) {
    return getScreenHeight(context) * 0.03; // 3% da altura da tela
  }

  static double getExtraLargeSpacing(BuildContext context) {
    return getScreenHeight(context) * 0.04; // 4% da altura da tela
  }

  // Padding responsivo
  static double getHorizontalPadding(BuildContext context) {
    return getScreenWidth(context) * 0.05; // 5% da largura da tela
  }

  static double getVerticalPadding(BuildContext context) {
    return getScreenHeight(context) * 0.02; // 2% da altura da tela
  }

  static double getCardPadding(BuildContext context) {
    return getScreenWidth(context) * 0.06; // 6% da largura da tela
  }

  // Tamanhos de ícones responsivos
  static double getIconSize(BuildContext context) {
    return getScreenWidth(context) * 0.05; // 5% da largura da tela
  }

  static double getLargeIconSize(BuildContext context) {
    return getScreenWidth(context) * 0.08; // 8% da largura da tela
  }

  // Altura mínima para botões (touch-friendly)
  static double getMinButtonHeight(BuildContext context) {
    return getScreenHeight(context) * 0.06; // 6% da altura da tela (mínimo 48px)
  }

  // Padding para inputs (touch-friendly)
  static EdgeInsets getInputPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: getScreenHeight(context) * 0.02,
      horizontal: getScreenWidth(context) * 0.03,
    );
  }

  // Verificar se é mobile
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < 768;
  }

  // Verificar se é tablet
  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) >= 768 && getScreenWidth(context) < 1024;
  }

  // Verificar se é desktop
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= 1024;
  }

  // Obter número de colunas baseado no tamanho da tela
  static int getColumnCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
