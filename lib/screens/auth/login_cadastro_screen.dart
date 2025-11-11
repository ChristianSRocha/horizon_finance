import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/auth/cadastro_screen.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';
import 'package:horizon_finance/features/auth/models/auth_state.dart';
import 'package:horizon_finance/features/users/services/user_service.dart';
import 'package:horizon_finance/screens/auth/renda_mensal_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';

class LoginCadastroScreen extends ConsumerStatefulWidget {
  const LoginCadastroScreen({super.key});

  @override
  ConsumerState<LoginCadastroScreen> createState() =>
      _LoginCadastroScreenState();
}

class _LoginCadastroScreenState extends ConsumerState<LoginCadastroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authServiceProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login feito com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // 1. Dispara a busca pelos dados do perfil.
      // O método agora é void, ele apenas atualiza o estado do provider.
      await ref.read(userServiceProvider.notifier).getProfile();
      // 2. Lê o estado que foi atualizado pelo método acima.
      final profile = ref.read(userServiceProvider);

      if (mounted) {
        if (profile != null && profile.onboardingComplete) {
          context.go('/dashboard');
        } else {
          context.go('/renda-mensal');
        }
      }
    } catch (e) {
      // O AuthService já atualizou o estado com a mensagem de erro
      // O listener abaixo irá exibir o SnackBar
    }
  }

  Future<void> _handlePasswordReset() async {
    final emailController = TextEditingController();
    bool isLoading = false;
    String? errorText;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Resetar Senha'),
              content: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Seu e-mail",
                  errorText: errorText,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    if (!isLoading) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Enviar'),
                  onPressed: () async {
                    if (isLoading) return;

                    if (emailController.text.isEmpty ||
                        !EmailValidator.validate(emailController.text)) {
                      setState(() {
                        errorText = 'E-mail inválido';
                      });
                      return;
                    }

                    setState(() {
                      errorText = null;
                      isLoading = true;
                    });

                    try {
                      await ref
                          .read(authServiceProvider.notifier)
                          .resetPassword(emailController.text.trim());
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Se uma conta existir para este e-mail, um link para reset de senha foi enviado.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao enviar e-mail de reset.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    // Observa o estado de autenticação para isLoading e erros
    final authState = ref.watch(authServiceProvider);
    final isLoading = authState.isLoading;

    ref.listen<AuthState>(authServiceProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Horizons Finance',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Seu futuro financeiro começa aqui',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildTextField(
                          context,
                          'E-mail',
                          Icons.email_outlined,
                          controller: _emailController,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe seu e-mail';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          context,
                          'Senha',
                          Icons.lock_outline,
                          isPassword: true,
                          enabled: !isLoading,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe sua senha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  )
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: isLoading ? null : _handlePasswordReset,
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () {
                              context.push('/cadastro');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Não tem uma conta? Cadastre-se',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
    );
  }
}
