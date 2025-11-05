import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/gotrue.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final supabase = Supabase.instance.client;
  bool _loading = false;
  bool _isConfirmed = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    try {
      final user = supabase.auth.currentUser;
      _email = user?.email;
      _isConfirmed = user?.emailConfirmedAt != null;
      if (_isConfirmed) _onConfirmed();
    } catch (_) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _checkConfirmed() async {
    setState(() => _loading = true);
    try {
      final user = supabase.auth.currentUser;
      _isConfirmed = user?.emailConfirmedAt != null;
      if (_isConfirmed) {
        _onConfirmed();
      } else {
        _showMessage('E‑mail ainda não confirmado. Verifique sua caixa de entrada.');
      }
    } catch (e) {
      _showMessage('Erro ao verificar status: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _resendVerification() async {
    if (_email == null) {
      _showMessage('E‑mail do usuário não disponível.');
      return;
    }
    setState(() => _loading = true);
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: _email,
      );
      _showMessage('E‑mail de verificação reenviado para $_email.');
    } catch (e) {
      _showMessage('Erro ao reenviar e-mail: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onConfirmed() {
    // Ajuste a navegação conforme sua app: '/dashboard' ou outra rota
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifique seu e‑mail'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.email_outlined, size: 72, color: primary),
            const SizedBox(height: 20),
            Text(
              'Um e‑mail de verificação foi enviado para:',
              style: TextStyle(color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _email ?? '—',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Abra o e‑mail e clique no link de confirmação. Só então você poderá continuar.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _checkConfirmed,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh),
              label: const Text('Já confirmei — Verificar'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loading ? null : _resendVerification,
              child: const Text('Reenviar e‑mail'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading ? null : () => Navigator.of(context).pushReplacementNamed('/login'),
              child: const Text('Voltar para login'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}