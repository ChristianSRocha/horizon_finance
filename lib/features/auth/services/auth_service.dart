import 'package:flutter_riverpod/flutter_riverpod.dart';
// IMPORTANTE: 'hide Provider' evita conflito com o Provider do Supabase
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, AuthState;
import '../models/auth_state.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authServiceProvider = NotifierProvider<AuthService, AuthState>(() {
  return AuthService();
});

class AuthService extends Notifier<AuthState> {
  SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
      );

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      if (response.user != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userId: response.user!.id,
          email: response.user!.email,
          name: name,
        );
      } else {
        throw Exception('Falha ao criar usuário');
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e.message),
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao criar sua conta: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userId: response.user!.id,
          email: response.user!.email,
        );

      return response.user!;
      
      } else {
        throw Exception('Falha ao fazer login');
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e.message),
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer login: ${e.toString()}',
      );
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = const AuthState();
  }


  Future<void> concluirOnboarding() async {

    final user = _supabase.auth.currentUser;

    if (user == null){
      throw Exception('Usuário não autenticado');
    }

    await _supabase
        .from('profiles')
        .update({'onboarding': true})
        .eq('id', user.id);

    return;
  }

  String _getErrorMessage(String message) {
    if (message.contains('already registered')) {
      return 'Este e-mail já está cadastrado';
    }
    if (message.contains('Invalid email')) {
      return 'E-mail inválido';
    }
    if (message.contains('Password')) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return message;
  }
}