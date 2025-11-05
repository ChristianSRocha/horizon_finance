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

  Future<Transaction> addTransactions({
    required String descricao,
    required String tipo,
    required double valor,
    DateTime? data, 
    int? diaDoMes,
    required int categoriaId,
    required bool fixedTransaction,
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
        'data': data?.toIso8601String(),
        'categoria_id': categoriaId,
        'status': 'ATIVO',
        'data_criacao': now.toIso8601String(),
        'fixed_transaction': fixedTransaction,
        'dia_do_mes': diaDoMes ?? null,
      };
      

      developer.log(
      '''- Descrição: ${dataToInsert['descricao']},
      - Tipo: ${dataToInsert['tipo']},
      - Valor: ${dataToInsert['valor']},
      - Usuario ID: ${dataToInsert['usuario_id']},
      - Categoria ID: ${dataToInsert['categoria_id']},
      - Status: ${dataToInsert['status']},
      - Data Criação: ${dataToInsert['data_criacao']}''', // <--- Aspas triplas aqui
      name: 'TransactionService',
    );

      //  ETAPA 2.2: CONSTRUÇÃO DA QUERY
      final query = _supabase
          .from(_transactions)
          .insert(dataToInsert)
          .select()
          .single();
      

      //  ETAPA 3: EXECUÇÃO
      final response = await query;
    

      //  ETAPA 4: CONVERSÃO JSON → DART
      return Transaction.fromJson(response);
      
    } on PostgrestException catch (e) {
      // Erro específico do Supabase
      throw Exception('Erro ao buscar: ${e.message}');
    } catch (e) {
      // Erro genérico
      throw Exception('Erro ao buscar: ${e.toString()}');
    }
  }
  
}