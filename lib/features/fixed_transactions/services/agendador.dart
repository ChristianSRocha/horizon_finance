// lib/features/fixed-transactions/services/agendador.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horizon_finance/features/fixed-transactions/services/fixed_transaction_service.dart';
import 'dart:developer' as developer;

/// Provider que gerencia o agendamento diário
final dailySchedulerProvider = Provider<DailyScheduler>((ref) {
  final fixedTransactionService = ref.read(fixedTransactionServiceProvider);
  return DailyScheduler(fixedTransactionService);
});

class DailyScheduler {
  final FixedTransactionService _fixedTransactionService;
  static const String _lastRunKey = 'last_recurrence_run_date';
  
  DailyScheduler(this._fixedTransactionService);

  /// Deve ser chamado no main() ou no initState do widget raiz
  Future<void> checkAndRunDaily() async {
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayString = _dateToString(today);
      
      // Recupera a última data de execução
      final lastRun = prefs.getString(_lastRunKey);
      
      developer.log(
        'Última execução: ${lastRun ?? "NUNCA"} | Hoje: $todayString',
        name: 'DailyScheduler',
      );
      
      // Se já rodou hoje, não precisa rodar novamente
      if (lastRun == todayString) {
        developer.log(
          'Processamento já executado hoje. Pulando...',
          name: 'DailyScheduler',
        );
        return;
      }
      
      // Executa o processamento
      developer.log('Iniciando processamento de recorrências...', 
          name: 'DailyScheduler');
      
      final created = await _fixedTransactionService.processDailyRecurrences(today);
      
      if (created.isNotEmpty) {
        developer.log(
          '${created.length} transação(ões) criada(s) com sucesso',
          name: 'DailyScheduler',
        );
        
        for (final transaction in created) {
          developer.log(
            '  - ${transaction.descricao}: R\$ ${transaction.valor.toStringAsFixed(2)}',
            name: 'DailyScheduler',
          );
        }
      } else {
        developer.log(
          'Nenhuma transação para gerar hoje',
          name: 'DailyScheduler',
        );
      }
      
      // Salva a data de hoje como última execução
      await prefs.setString(_lastRunKey, todayString);
      
      // Se mudou de mês desde a última execução, processa retroativos
      if (lastRun != null && _isDifferentMonth(lastRun, todayString)) {
        developer.log(
          'Mudança de mês detectada! Processando retroativos...',
          name: 'DailyScheduler',
        );
        
        final retroactive = await _fixedTransactionService.processRetroactiveTemplates();
        
        if (retroactive.isNotEmpty) {
          developer.log(
            '${retroactive.length} transação(ões) retroativa(s) criada(s)',
            name: 'DailyScheduler',
          );
        }
      }
      
    } catch (e, stackTrace) {
      developer.log(
        'Erro no processamento diário',
        name: 'DailyScheduler',
        error: e,
        stackTrace: stackTrace,
      );
      // Não bloqueia o app em caso de erro
    }
  }

  /// Força a execução imediata (para testes ou botão manual)
  Future<void> forceRun() async {
    developer.log('Forçando execução manual...', name: 'DailyScheduler');
    
    final created = await _fixedTransactionService.processDailyRecurrences();
    
    developer.log(
      'Execução manual concluída: ${created.length} transação(ões)',
      name: 'DailyScheduler',
    );
    
    // Atualiza a data de última execução
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRunKey, _dateToString(DateTime.now()));
  }

  Future<void> resetSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastRunKey);
    developer.log('Agendamento resetado', name: 'DailyScheduler');
  }

  /// Verifica o status atual do agendador
  Future<Map<String, dynamic>> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRun = prefs.getString(_lastRunKey);
    final today = _dateToString(DateTime.now());
    
    return {
      'lastRun': lastRun,
      'today': today,
      'wasRunToday': lastRun == today,
      'nextRun': lastRun == today ? 'Amanhã' : 'Hoje',
    };
  }


  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isDifferentMonth(String date1String, String date2String) {
    try {
      final parts1 = date1String.split('-');
      final parts2 = date2String.split('-');
      
      // Compara ano e mês
      return parts1[0] != parts2[0] || parts1[1] != parts2[1];
    } catch (e) {
      return true; // Em caso de erro, considera como mês diferente
    }
  }
}

/// ========== EXEMPLO DE USO NO MAIN ==========
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    
    // Executa o processamento diário ao iniciar o app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailySchedulerProvider).checkAndRunDaily();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}
*/