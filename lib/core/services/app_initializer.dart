// lib/core/services/app_initializer.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horizon_finance/features/fixed-transactions/services/fixed_transaction_service.dart';
import 'dart:developer' as developer;

/// Provider que gerencia a inicialização do app
final appInitializerProvider = Provider<AppInitializer>((ref) {
  final fixedTransactionService = ref.read(fixedTransactionServiceProvider);
  return AppInitializer(fixedTransactionService);
});

class AppInitializer {
  final FixedTransactionService _fixedTransactionService;
  static const String _lastProcessedDateKey = 'last_processed_date';
  
  AppInitializer(this._fixedTransactionService);

  /// Deve ser chamado no main() ou no initState do widget raiz
  Future<void> initialize() async {
    developer.log('Inicializando app...', name: 'AppInitializer');
    
    try {
      await _processFixedTransactionsIfNeeded();
      developer.log('App inicializado com sucesso', name: 'AppInitializer');
    } catch (e, stackTrace) {
      developer.log(
        'Erro na inicialização',
        name: 'AppInitializer',
        error: e,
        stackTrace: stackTrace,
      );
      // Não bloqueia o app em caso de erro
    }
  }

  /// Verifica se precisa processar transações fixas
  Future<void> _processFixedTransactionsIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    // Recupera a última data processada
    final lastProcessedDate = prefs.getString(_lastProcessedDateKey);
    
    developer.log(
      'Última execução: ${lastProcessedDate ?? "NUNCA"} | Hoje: $todayString',
      name: 'AppInitializer',
    );
    
    // *** IMPORTANTE: Em desenvolvimento, sempre processa ***

    final shouldProcess = lastProcessedDate != todayString;
    
    if (!shouldProcess) {
      developer.log(
        'Transações fixas já processadas hoje',
        name: 'AppInitializer',
      );
      
      // *** DEBUG: Mostra quantos templates existem ***
      try {
        final templates = await _fixedTransactionService.getActiveTemplates();
        if (templates.isNotEmpty) {
          for (final template in templates) {
            developer.log(
              '  - ${template.descricao} (dia ${template.diaDoMes})',
              name: 'AppInitializer',
            );
          }
        }
      } catch (e) {
        developer.log('Erro ao listar templates: $e', name: 'AppInitializer');
      }
      
      return;
    }
    
    // Processa transações fixas
    
    try {
      // Primeiro, verifica se há transações pendentes
      final pendingTemplates = await _fixedTransactionService.checkPendingTransactions();
      
      if (pendingTemplates.isNotEmpty) {
        developer.log(
          '⚠️ ${pendingTemplates.length} template(s) com transações pendentes detectado(s)',
          name: 'AppInitializer',
        );
        
        // Processa templates retroativos primeiro para criar as pendentes
        final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
        
        if (retroactive.isNotEmpty) {
          developer.log(
            '✅ ${retroactive.length} transação(ões) pendente(s) criada(s)',
            name: 'AppInitializer',
          );
        }
      }
      
      // Depois processa templates do mês atual (para hoje e dias futuros que já passaram)
      final created = await _fixedTransactionService.processMonthlyTemplates();
      
      if (created.isNotEmpty) {
        developer.log(
          '✅ ${created.length} transação(ões) fixa(s) criada(s) para o mês atual',
          name: 'AppInitializer',
        );
      } else {
        // Debug: mostra templates
        final templates = await _fixedTransactionService.getActiveTemplates();
  
        if (templates.isNotEmpty) {
          developer.log(
            'Templates ativos encontrados: ${templates.length}',
            name: 'AppInitializer',
          );
          for (final template in templates) {
            developer.log(
              '  - ${template.descricao} configurado para dia ${template.diaDoMes}',
              name: 'AppInitializer',
            );
          }
        }
      }
      
      // Salva a data de hoje como última processada
      await prefs.setString(_lastProcessedDateKey, todayString);
      
      // Se for a primeira execução ou mudou de mês, processa retroativos novamente
      // (caso tenha perdido alguma transação)
      if (lastProcessedDate == null || _isDifferentMonth(lastProcessedDate, todayString)) {
        developer.log(
          'Primeira execução ou mudança de mês detectada, processando retroativos...',
          name: 'AppInitializer',
        );

        final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
        
        if (retroactive.isNotEmpty) {
          developer.log(
            '✅ ${retroactive.length} transação(ões) retroativa(s) criada(s)',
            name: 'AppInitializer',
          );
        }
      }
    } catch (e, stackTrace) {
      developer.log(
        'Erro ao processar transações',
        name: 'AppInitializer',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Verifica se as datas estão em meses diferentes
  bool _isDifferentMonth(String date1String, String date2String) {
    try {
      final parts1 = date1String.split('-');
      final parts2 = date2String.split('-');
      
      return parts1[0] != parts2[0] || parts1[1] != parts2[1]; // ano ou mês diferente
    } catch (e) {
      return true; // Em caso de erro, considera como mês diferente
    }
  }

  /// Força o processamento imediato (útil para testes ou botão manual)
  Future<void> forceProcess() async {
    // Lista templates primeiro
    final templates = await _fixedTransactionService.getActiveTemplates();
    
    if (templates.isEmpty) {
      return;
    }
   
    
    final created = await _fixedTransactionService.processMonthlyTemplates();
    final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
    
    developer.log(
      'Processamento forçado: ${created.length} novas + ${retroactive.length} retroativas',
      name: 'AppInitializer',
    );
    
    // Atualiza a data de última execução
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await prefs.setString(_lastProcessedDateKey, todayString);
  }

  /// Reseta o controle de processamento (útil para testes)
  Future<void> resetProcessingControl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastProcessedDateKey);
  }
  
  /// Verifica status atual 
  Future<Map<String, dynamic>> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastProcessedDate = prefs.getString(_lastProcessedDateKey);
    final templates = await _fixedTransactionService.getActiveTemplates();
    
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return {
      'lastProcessedDate': lastProcessedDate,
      'todayString': todayString,
      'wasProcessedToday': lastProcessedDate == todayString,
      'templatesCount': templates.length,
      'templates': templates,
    };
  }
}