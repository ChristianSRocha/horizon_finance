import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, AuthState;
import "../models/fixed_transactions.dart";

// Provider do SupabaseClient (Singleton)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider do Service
final fixedTransactionServiceProvider = Provider<FixedTransactionService>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return FixedTransactionService(supabase);
});


class FixedTransactionService {
  final SupabaseClient _supabase;
  static const String _fixedTransactions = 'fixed_transactions';
  
  FixedTransactionService(this._supabase);

  Future<List<FixedTransaction>> getFixedTransactions() async {
    try {
      //  ETAPA 1: VALIDAÇÃO
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      

      //  ETAPA 2: CONSTRUÇÃO DA QUERY
      final query = _supabase
          .from(_fixedTransactions)
          .select()
          // eq() → Equivale a WHERE campo = valor
          .eq('usuario_id', userId)
          // order() → Equivale a ORDER BY campo
          .order('dia_do_mes', ascending: true);
      

      //  ETAPA 3: EXECUÇÃO
      final response = await query;
    

      //  ETAPA 4: CONVERSÃO JSON → DART
      return (response as List)
          .map((json) => FixedTransaction.fromJson(json))
          .toList();
      
    } on PostgrestException catch (e) {
      // Erro específico do Supabase
      throw Exception('Erro ao buscar: ${e.message}');
    } catch (e) {
      // Erro genérico
      throw Exception('Erro ao buscar: ${e.toString()}');
    }
  }

  Future<List<FixedTransaction>> addFixedTransactions({
    required String descricao,
    required String usuarioId,
    required String tipo,
    required double valor,
    required int dia, 
    required int categoriaId
  }) async {
    
    try {
      //  ETAPA 1: VALIDAÇÃO
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      

      //  ETAPA 2: CONSTRUÇÃO DA QUERY
      final query = _supabase
          .from(_fixedTransactions)
          .insert({
            'descricao': descricao,
            'usuarioId': usuarioId,
            'tipo': tipo,
            'valor': valor,
            'dia': dia,
            'categoriaId': categoriaId
            'status': 'ATIVO',
            'dataCriacao': DateTime.now()
          })
      

      //  ETAPA 3: EXECUÇÃO
      final response = await query;
    

      //  ETAPA 4: CONVERSÃO JSON → DART
      return (response as List)
          .map((json) => FixedTransaction.fromJson(json))
          .toList();
      
    } on PostgrestException catch (e) {
      // Erro específico do Supabase
      throw Exception('Erro ao buscar: ${e.message}');
    } catch (e) {
      // Erro genérico
      throw Exception('Erro ao buscar: ${e.toString()}');
    }
  }
  
}