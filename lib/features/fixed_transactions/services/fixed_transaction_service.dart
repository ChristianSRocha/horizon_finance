import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';

final fixedTransactionServiceProvider = Provider<FixedTransactionService>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return FixedTransactionService(supabase);
});

class FixedTransactionService {
  final SupabaseClient _supabase;
  static const String _tableName = 'transactions';

  FixedTransactionService(this._supabase);

  Future<List<Transaction>> getActiveTemplates() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('usuario_id', userId)
          .eq('fixed_transaction', true)
          .eq('status', 'ATIVO')
          .order('dia_do_mes', ascending: true);

      return (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      print('Erro ao buscar templates: $e');
      rethrow;
    }
  }

  Future<bool> hasMonthlyInstanceForTemplate({
    required String templateId,
    required int year,
    required int month,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0, 23, 59, 59);

      final template = await _supabase
          .from(_tableName)
          .select('descricao, categoria_id, tipo')
          .eq('id', templateId)
          .single();

      final response = await _supabase
          .from(_tableName)
          .select('id')
          .eq('usuario_id', userId)
          .eq('fixed_transaction', false)
          .eq('descricao', template['descricao'])
          .eq('categoria_id', template['categoria_id'])
          .eq('tipo', template['tipo'])
          .gte('data', firstDay.toIso8601String())
          .lte('data', lastDay.toIso8601String())
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      print('Erro ao verificar instância mensal: $e');
      return false;
    }
  }

  Future<Transaction?> createMonthlyInstance({
    required Transaction template,
    required int year,
    required int month,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final alreadyExists = await hasMonthlyInstanceForTemplate(
        templateId: template.id,
        year: year,
        month: month,
      );

      if (alreadyExists) {
        print('Instância já existe para ${template.descricao} em $month/$year');
        return null;
      }

      final diaDoMes = template.diaDoMes ?? 1;
      final lastDayOfMonth = DateTime(year, month + 1, 0).day;
      final diaAjustado = diaDoMes > lastDayOfMonth ? lastDayOfMonth : diaDoMes;

      final dataTransacao = DateTime(year, month, diaAjustado, 12, 0, 0);

      final Map<String, dynamic> newTransaction = {
        'usuario_id': userId,
        'tipo': template.tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA',
        'descricao': template.descricao,
        'valor': template.valor,
        'data': dataTransacao.toIso8601String(),
        'categoria_id': template.categoriaId,
        'fixed_transaction': false,
        'status': 'ATIVO',
        'data_criacao': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from(_tableName)
          .insert(newTransaction)
          .select()
          .single();

      print('Instância criada: ${template.descricao} - ${dataTransacao.day}/$month/$year');

      return Transaction.fromJson(response);
    } catch (e) {
      print('Erro ao criar instância mensal: $e');
      return null;
    }
  }

  Future<List<Transaction>> processMonthlyTemplates() async {
    try {
      final now = DateTime.now();
      final templates = await getActiveTemplates();

      if (templates.isEmpty) {
        print('Nenhum template ativo encontrado');
        return [];
      }

      print('Processando ${templates.length} template(s) para ${now.month}/${now.year}');

      final List<Transaction> created = [];

      for (final template in templates) {
        final instance = await createMonthlyInstance(
          template: template,
          year: now.year,
          month: now.month,
        );

        if (instance != null) {
          created.add(instance);
        }
      }

      print('Total de ${created.length} transação(ões) criada(s)');
      return created;
    } catch (e) {
      print('Erro ao processar templates mensais: $e');
      return [];
    }
  }

  Future<List<Transaction>> processRetroactiveTemplates() async {
    try {
      final templates = await getActiveTemplates();

      if (templates.isEmpty) {
        return [];
      }

      final now = DateTime.now();
      final List<Transaction> created = [];

      for (final template in templates) {
        final templateCreationDate = template.dataCriacao;

        DateTime checkDate = DateTime(
          templateCreationDate.year,
          templateCreationDate.month,
        );

        while (checkDate.isBefore(DateTime(now.year, now.month))) {
          final instance = await createMonthlyInstance(
            template: template,
            year: checkDate.year,
            month: checkDate.month,
          );

          if (instance != null) {
            created.add(instance);
          }

          checkDate = DateTime(checkDate.year, checkDate.month + 1);
        }
      }

      if (created.isNotEmpty) {
        print('${created.length} transação(ões) retroativa(s) criada(s)');
      }

      return created;
    } catch (e) {
      print('Erro ao processar templates retroativos: $e');
      return [];
    }
  }

  Future<List<Transaction>> checkPendingTransactions() async {
    try {
      final templates = await getActiveTemplates();
      final now = DateTime.now();
      final List<Transaction> pendingTemplates = [];

      for (final template in templates) {
        final hasInstance = await hasMonthlyInstanceForTemplate(
          templateId: template.id,
          year: now.year,
          month: now.month,
        );

        if (!hasInstance) {
          pendingTemplates.add(template);
        }
      }

      return pendingTemplates;
    } catch (e) {
      print('Erro ao verificar transações pendentes: $e');
      return [];
    }
  }
}
