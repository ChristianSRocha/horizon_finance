import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/features/fixed-transactions/models/fixed_transaction.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

final fixedTransactionServiceProvider = Provider<FixedTransactionService>((ref) {
  final supabase = Supabase.instance.client;
  return FixedTransactionService(supabase);
});

class FixedTransactionService {
  final SupabaseClient _supabase;
  static const String _templates = 'fixed_transaction_templates';
  static const String _transactions = 'transactions';
  
  FixedTransactionService(this._supabase);

  /// Cria um template de transação fixa (não cria a transação ainda)
  Future<FixedTransactionTemplate> createTemplate({
    required String descricao,
    required TransactionType tipo,
    required double valor,
    required int diaDoMes,
    required int categoriaId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final dataToInsert = {
        'usuario_id': userId,
        'tipo': tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA',
        'descricao': descricao,
        'valor': valor,
        'dia_do_mes': diaDoMes,
        'categoria_id': categoriaId,
        'ativo': true,
      };

      developer.log(
        'Criando template: $descricao no dia $diaDoMes',
        name: 'FixedTransactionService',
      );

      final response = await _supabase
          .from(_templates)
          .insert(dataToInsert)
          .select()
          .single();

      return FixedTransactionTemplate.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar template: ${e.toString()}');
    }
  }

  /// Lista todos os templates ativos do usuário
  Future<List<FixedTransactionTemplate>> getActiveTemplates() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _supabase
          .from(_templates)
          .select()
          .eq('usuario_id', userId)
          .eq('ativo', true)
          .order('dia_do_mes', ascending: true);

      return (response as List)
          .map((json) => FixedTransactionTemplate.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar templates: ${e.toString()}');
    }
  }

  /// Desativa um template (soft delete)
  Future<void> deactivateTemplate(String templateId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _supabase
          .from(_templates)
          .update({'ativo': false})
          .eq('id', templateId)
          .eq('usuario_id', userId);
    } catch (e) {
      throw Exception('Erro ao desativar template: ${e.toString()}');
    }
  }

  /// FUNÇÃO PRINCIPAL: Processa templates e cria transações para o mês atual
  Future<List<Transaction>> processMonthlyTemplates() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // 1. Busca todos os templates ativos
      final templates = await getActiveTemplates();
      
      if (templates.isEmpty) {
        developer.log('Nenhum template ativo encontrado', name: 'ProcessTemplates');
        return [];
      }

      // 2. Calcula o período do mês atual
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month);
      final nextMonth = DateTime(now.year, now.month + 1);

      // 3. Verifica quais templates já foram processados este mês
      final createdTransactions = <Transaction>[];

      for (final template in templates) {
        // Calcula a data da transação para este mês
        int targetDay = template.diaDoMes;
        
        // Ajusta para o último dia do mês se necessário (ex: dia 31 em fevereiro)
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
        if (targetDay > lastDayOfMonth) {
          targetDay = lastDayOfMonth;
        }

        final transactionDate = DateTime(now.year, now.month, targetDay);

        // Só processa se a data já passou ou é hoje
        if (transactionDate.isAfter(now)) {
          developer.log(
            'Template "${template.descricao}" será processado em ${transactionDate.day}/${transactionDate.month}',
            name: 'ProcessTemplates',
          );
          continue;
        }

        // Verifica se já existe transação para este template neste mês
        final existingTransaction = await _checkExistingTransaction(
          templateId: template.id,
          month: currentMonth,
        );

        if (existingTransaction != null) {
          developer.log(
            'Template "${template.descricao}" já processado este mês',
            name: 'ProcessTemplates',
          );
          continue;
        }

        // Cria a transação
        final transaction = await _createTransactionFromTemplate(
          template: template,
          date: transactionDate,
        );

        createdTransactions.add(transaction);
        
        developer.log(
          'Transação criada: "${template.descricao}" - R\$ ${template.valor.toStringAsFixed(2)}',
          name: 'ProcessTemplates',
        );
      }

      return createdTransactions;
    } catch (e) {
      developer.log(
        'Erro ao processar templates: ${e.toString()}',
        name: 'ProcessTemplates',
        error: e,
      );
      throw Exception('Erro ao processar templates: ${e.toString()}');
    }
  }

  /// Verifica se já existe transação para este template no mês
  Future<Transaction?> _checkExistingTransaction({
    required String templateId,
    required DateTime month,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final response = await _supabase
          .from(_transactions)
          .select()
          .eq('usuario_id', userId)
          .eq('fixed_transaction', true)
          .eq('template_id', templateId) 
          .gte('data', firstDay.toIso8601String())
          .lte('data', lastDay.toIso8601String())
          .maybeSingle();

      if (response == null) return null;
      return Transaction.fromJson(response);
    } catch (e) {
      return null;
    }
  }

 
  Future<Transaction> _createTransactionFromTemplate({
    required FixedTransactionTemplate template,
    required DateTime date,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }

    final dataToInsert = {
      'usuario_id': userId,
      'tipo': template.tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA',
      'descricao': template.descricao,
      'valor': template.valor,
      'data': date.toIso8601String(),
      'categoria_id': template.categoriaId,
      'fixed_transaction': true,
      'template_id': template.id,
      'status': 'ATIVO',
      'data_criacao': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from(_transactions)
        .insert(dataToInsert)
        .select()
        .single();

    return Transaction.fromJson(response);
  }

  /// Atualiza um template existente
  Future<FixedTransactionTemplate> updateTemplate({
    required String templateId,
    required String descricao,
    required double valor,
    required int diaDoMes,
    required int categoriaId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final dataToUpdate = {
        'descricao': descricao,
        'valor': valor,
        'dia_do_mes': diaDoMes,
        'categoria_id': categoriaId,
      };

      final response = await _supabase
          .from(_templates)
          .update(dataToUpdate)
          .eq('id', templateId)
          .eq('usuario_id', userId)
          .select()
          .single();

      return FixedTransactionTemplate.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar template: ${e.toString()}');
    }
  }
}