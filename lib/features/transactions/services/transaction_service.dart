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


class DashboardData {
  final double saldoAtual;
  final double receitasMes;
  final double despesasMes;
  final List<Transaction> ultimasTransacoes;

  DashboardData({
    required this.saldoAtual,
    required this.receitasMes,
    required this.despesasMes,
    required this.ultimasTransacoes,
  });
}


class TransactionService {
  final SupabaseClient _supabase;
  static const String _transactions = 'transactions';
  
  TransactionService(this._supabase);

  Future<DashboardData> getDashboardData() async {
  
    try {

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Dados para buscar as transações do mês atual
      final now = DateTime.now();
      final primeiroDia = DateTime(now.year, now.month, 1);
      final ultimoDia = DateTime(now.year, now.month + 1, 0, 23, 59, 59);


      final response = await _supabase
          .from(_transactions)
          .select()
          .eq('usuario_id', userId)
          .gte('data_criacao', primeiroDia.toIso8601String())
          .lte('data_criacao', ultimoDia.toIso8601String())
          .order('data_criacao', ascending: false);

      final transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      final receitasMes = transactions
          .where((t) => t.tipo == TransactionType.receita)
          .fold<double>(0, (sum, t) => sum + t.valor);
      
      final despesasMes = transactions
          .where((t) => t.tipo == TransactionType.despesa)
          .fold<double>(0, (sum, t) => sum + t.valor);

      final saldoAtual = receitasMes - despesasMes;

      final ultimasTransacoesFiltradas = transactions
          .where((t) => t.fixedTransaction == false)
          .take(5) 
          .toList();

      return DashboardData(
        saldoAtual: saldoAtual,
        receitasMes: receitasMes,
        despesasMes: despesasMes,
        ultimasTransacoes: ultimasTransacoesFiltradas,
      );
    
    } on PostgrestException catch(e) {
      throw Exception('Erro ao buscar dados do dashboard: ${e.message}');
    
    } catch (e) {
      throw Exception('Erro ao buscar dados do dashboard: ${e.toString()}');
    }
  } 

  /// Busca apenas as receitas do mês atual
  Future<double> getReceitasMesAtual() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final response = await _supabase
          .from(_transactions)
          .select('valor')
          .eq('usuario_id', userId)
          .eq('tipo', 'RECEITA')
          .gte('data_criacao', firstDayOfMonth.toIso8601String())
          .lte('data_criacao', lastDayOfMonth.toIso8601String());

      final total = (response as List)
          .fold<double>(0, (sum, item) => sum + (item['valor'] as num).toDouble());

      return total;

    } catch (e) {
      throw Exception('Erro ao buscar receitas: ${e.toString()}');
    }
  }

  /// Busca apenas as despesas do mês atual
  Future<double> getDespesasMesAtual() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final response = await _supabase
          .from(_transactions)
          .select('valor')
          .eq('usuario_id', userId)
          .eq('tipo', 'DESPESA')
          .gte('data_criacao', firstDayOfMonth.toIso8601String())
          .lte('data_criacao', lastDayOfMonth.toIso8601String());

      final total = (response as List)
          .fold<double>(0, (sum, item) => sum + (item['valor'] as num).toDouble());

      return total;

    } catch (e) {
      throw Exception('Erro ao buscar despesas: ${e.toString()}');
    }
  }

  /// Busca as últimas transações do usuário
  Future<List<Transaction>> getUltimasTransacoes({int limit = 5}) async {
    try {

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _supabase
          .from(_transactions)
          .select()
          .eq('usuario_id', userId)
          .order('data_criacao', ascending: false)
          .limit(limit);

      final transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();


      return transactions;

    } catch (e) {
      throw Exception('Erro ao buscar transações: ${e.toString()}');
    }
  }

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

  Future<Transaction> addTransaction({
    required String descricao,
    required TransactionType tipo,
    required double valor,
    DateTime? data, 
    int? diaDoMes,
    required int categoriaId,
    bool? fixedTransaction,
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
      final tipoString = tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA';

      final dataToInsert = {
        'descricao': descricao,
        'usuario_id': userId,
        'tipo': tipoString,
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

      //  ETAPA 3: CONSTRUÇÃO DA QUERY
      final response = await _supabase
          .from(_transactions)
          .insert(dataToInsert)
          .select()
          .single();
      
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


  Future<Transaction> updateTransaction({
    required String id,
    required String descricao,
    required TransactionType tipo,
    required double valor,
    required DateTime data,
    required int categoriaId,
    required bool fixedTransaction,
  }) async {
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final tipoString = tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA';
      
      final dataToUpdate = {
        'descricao': descricao,
        'tipo': tipoString,
        'valor': valor,
        'data': data.toIso8601String(),
        'categoria_id': categoriaId,
        'fixed_transaction': fixedTransaction,
      };


      final response = await _supabase
          .from(_transactions)
          .update(dataToUpdate)
          .eq('id', id)
          .eq('usuario_id', userId) // Segurança: só atualiza se for do usuário
          .select()
          .single();

      return Transaction.fromJson(response);
      
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar transação: ${e.message}');

    } catch (e) {
      throw Exception('Erro ao atualizar transação: ${e.toString()}');
    }
  }

  /// Deleta uma transação (soft delete - muda status para INATIVO)
  Future<void> deleteTransaction(String id) async {
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Soft delete: apenas muda o status
      await _supabase
          .from(_transactions)
          .update({'status': 'INATIVO'})
          .eq('id', id)
          .eq('usuario_id', userId); 

      
    } on PostgrestException catch (e) {
      throw Exception('Erro ao deletar transação: ${e.message}');

    } catch (e) {
      throw Exception('Erro ao deletar transação: ${e.toString()}');
    }
  }

  
}