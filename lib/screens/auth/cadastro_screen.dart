import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/features/auth/services/auth_service.dart';

// MUDANÇA 1: StatefulWidget → ConsumerStatefulWidget
class CadastroScreen extends ConsumerStatefulWidget {
  const CadastroScreen({super.key});

  @override
  ConsumerState<CadastroScreen> createState() => _CadastroScreenState();
}

// MUDANÇA 2: State → ConsumerState (agora tem acesso ao 'ref')
class _CadastroScreenState extends ConsumerState<CadastroScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Removido _isLoading daqui, agora vem do AuthState

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // MUDANÇA 3: Conectar ao AuthService do Supabase

  Future<void> _handleCadastro() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Chama o AuthService usando Riverpod
        await ref.read(authServiceProvider.notifier).signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _usernameController.text.trim(),
            );

        // Sucesso no cadastro: direciona para a tela de verificação de e‑mail
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta criada com sucesso! Verifique seu e‑mail.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          context.go('/login');
        }
      } catch (e) {
        // Erro no cadastro
        if (mounted) {
          final errorMessage = ref.read(authServiceProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(errorMessage ?? 'Erro ao criar conta. Tente novamente.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    // MUDANÇA 4: Observa o estado de autenticação
    final authState = ref.watch(authServiceProvider);
    final isLoading = authState.isLoading;

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
                          'Nome de Usuário',
                          Icons.person_outline,
                          _usernameController,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome de usuário.';
                            }
                            if (value.trim().length < 3) {
                              return 'Nome deve ter no mínimo 3 caracteres.';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          'E-mail',
                          Icons.email_outlined,
                          _emailController,
                          (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Por favor, insira um e-mail válido.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          'Senha',
                          Icons.lock_outline,
                          _passwordController,
                          (value) {
                            if (value == null || value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres.';
                            }
                            return null;
                          },
                          isPassword: true,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          'Confirme a Senha',
                          Icons.lock_outline,
                          _confirmPasswordController,
                          (value) {
                            if (value != _passwordController.text) {
                              return 'As senhas não coincidem.';
                            }
                            return null;
                          },
                          isPassword: true,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleCadastro,
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
                                    'Cadastrar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.push('/login');
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
                              'Já tem uma conta? Entrar',
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
    String label,
    IconData icon,
    TextEditingController controller,
    String? Function(String?) validator, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true, // MUDANÇA 6: Adiciona parâmetro enabled
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled, // MUDANÇA 7: Usa o parâmetro enabled
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
