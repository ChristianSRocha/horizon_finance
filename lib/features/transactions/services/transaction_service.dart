import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, AuthState;
import "../models/transactions.dart";
import 'dart:developer' as developer;


// Provider do SupabaseClient (Singleton)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider do Service
final TransactionServiceProvider = Provider<TransactionService>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TransactionService(supabase);
});


class TransactionService {
  final SupabaseClient _supabase;
  static const String _transactions = 'transactions';
  
  TransactionService(this._supabase);

  Future<List<Transaction>> getFixedTransactions() async {
    try {
      //  ETAPA 1: VALIDAÇÃO
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      

      //  ETAPA 2: CONSTRUÇÃO DA QUERY
      final query = _supabase
          .from(_transactions)
          .select()
          // eq() → Equivale a WHERE campo = valor
          .eq('usuario_id', userId)
          // order() → Equivale a ORDER BY campo
          .order('dia_do_mes', ascending: true);
      

      //  ETAPA 3: EXECUÇÃO
      final response = await query;
    

      //  ETAPA 4: CONVERSÃO JSON → DART
      return (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
      
    } on PostgrestException catch (e) {
      // Erro específico do Supabase
      throw Exception('Erro ao buscar: ${e.message}');
    } catch (e) {
      // Erro genérico
      throw Exception('Erro ao buscar: ${e.toString()}');
    }
  }

  Future<List<Transaction>> addTransactions({
    required String descricao,
    required String tipo,
    required double valor,
    required DateTime data, 
    required int categoriaId
  }) async {


    developer.log(
      'Valor a salvar(BACKEND): R\$ ${valor.toStringAsFixed(2)}',
      name: 'TransactionService',
    );
    
    try {
      //  ETAPA 1: VALIDAÇÃO
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      
       //  ETAPA 2: CONSTRUÇÃO DOS DADOS
      final now = DateTime.now();
      final dataToInsert = {
        'descricao': descricao,
        'usuario_id': userId,
        'tipo': tipo,
        'valor': valor,
        'data': now.toIso8601String(),
        'categoria_id': categoriaId,
        'status': 'ATIVO',
        'data_criacao': now.toIso8601String(),
      };
      
      developer.log(
        '📝 Dados preparados para inserção:',
        name: 'TransactionService',
      );
      developer.log(
        '   - Descrição: ${dataToInsert['descricao']}',
        name: 'TransactionService',
      );
      developer.log(
        '   - Tipo: ${dataToInsert['tipo']}',
        name: 'TransactionService',
      );
      developer.log(
        '   - Valor: ${dataToInsert['valor']}',
        name: 'TransactionService',
      );
      developer.log(
        '   - Usuario ID: ${dataToInsert['usuario_id']}',
        name: 'TransactionService',
      );
      //  ETAPA 2: CONSTRUÇÃO DA QUERY
      final query = _supabase
          .from(_transactions)
          .insert({
            'descricao': descricao,
            'usuarioId': usuarioId,
            'tipo': tipo,
            'valor': valor,
            'data': data,
            'categoriaId': categoriaId,
            'status': 'ATIVO',
            'dataCriacao': DateTime.now()
          });
      

      //  ETAPA 3: EXECUÇÃO
      final response = await query;
    

      //  ETAPA 4: CONVERSÃO JSON → DART
      return (response as List)
          .map((json) => Transaction.fromJson(json))
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