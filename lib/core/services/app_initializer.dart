// lib/core/services/app_initializer.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horizon_finance/features/fixed_transactions/services/fixed_transaction_service.dart';

/// Provider que gerencia a inicialização do app
final appInitializerProvider = Provider<AppInitializer>((ref) {
  final fixedTransactionService = ref.read(fixedTransactionServiceProvider);
  return AppInitializer(fixedTransactionService);
});

class AppInitializer {
  final FixedTransactionService _fixedTransactionService;
  static const String _lastProcessedMonthKey = 'last_processed_month';
  
  AppInitializer(this._fixedTransactionService);

  Future<void> initialize() async {
    print('Inicializando app...');
    
    try {
      await _processFixedTransactionsIfNeeded();
      print('App inicializado com sucesso');
    } catch (e, stackTrace) {
      print('Erro na inicialização: $e');
      print(stackTrace);
    }
  }

  Future<void> _processFixedTransactionsIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    final lastProcessedMonth = prefs.getString(_lastProcessedMonthKey);
    
    print('Último mês processado: ${lastProcessedMonth ?? "NUNCA"} | Mês atual: $currentMonthKey');
    
    if (lastProcessedMonth == currentMonthKey) {
      print('Transações fixas já processadas para este mês');
      return;
    }
    
    print('Novo mês detectado. Processando templates...');
    
    try {
      final templates = await _fixedTransactionService.getActiveTemplates();
      
      if (templates.isEmpty) {
        print('Nenhum template ativo encontrado');
        await prefs.setString(_lastProcessedMonthKey, currentMonthKey);
        return;
      }

      print('${templates.length} template(s) ativo(s) encontrado(s):');
      for (final template in templates) {
        print(' - ${template.descricao} (dia ${template.diaDoMes})');
      }
      
      final pendingTemplates = await _fixedTransactionService.checkPendingTransactions();
      
      if (pendingTemplates.isNotEmpty) {
        print('${pendingTemplates.length} template(s) com transações pendentes');
        
        final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
        
        if (retroactive.isNotEmpty) {
          print('${retroactive.length} transação(ões) retroativa(s) criada(s)');
        }
      }
      
      final created = await _fixedTransactionService.processMonthlyTemplates();
      
      if (created.isNotEmpty) {
        print('${created.length} transação(ões) criada(s) para ${now.month}/${now.year}');
        
        for (final transaction in created) {
          print(' - ${transaction.descricao}: R\$ ${transaction.valor.toStringAsFixed(2)}');
        }
      } else {
        print('Nenhuma nova transação criada');
      }
      
      await prefs.setString(_lastProcessedMonthKey, currentMonthKey);
      print('Processamento concluído. Mês registrado: $currentMonthKey');
      
    } catch (e, stackTrace) {
      print('Erro ao processar transações: $e');
      print(stackTrace);
    }
  }

  Future<void> forceProcess() async {
    print('Processamento manual iniciado...');
    
    try {
      final templates = await _fixedTransactionService.getActiveTemplates();
      
      if (templates.isEmpty) {
        print('Nenhum template para processar');
        return;
      }
      
      print('${templates.length} template(s) encontrado(s)');
      
      final created = await _fixedTransactionService.processMonthlyTemplates();
      final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
      
      print('Processamento manual: ${created.length} novas + ${retroactive.length} retroativas');
      
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await prefs.setString(_lastProcessedMonthKey, currentMonthKey);
      
    } catch (e, stackTrace) {
      print('Erro no processamento manual: $e');
      print(stackTrace);
    }
  }

  Future<void> resetProcessingControl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastProcessedMonthKey);
    print('Controle de processamento resetado');
  }
  
  Future<Map<String, dynamic>> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastProcessedMonth = prefs.getString(_lastProcessedMonthKey);
    final templates = await _fixedTransactionService.getActiveTemplates();
    
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    return {
      'lastProcessedMonth': lastProcessedMonth,
      'currentMonthKey': currentMonthKey,
      'wasProcessedThisMonth': lastProcessedMonth == currentMonthKey,
      'templatesCount': templates.length,
      'templates': templates,
    };
  }
}
