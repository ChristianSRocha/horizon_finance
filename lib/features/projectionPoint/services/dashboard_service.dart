import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/projection_point.dart';

class DashboardService {
  final _supabase = Supabase.instance.client;

  /// Busca o saldo atual calculando todas as transações do usuário
  Future<double> getCurrentBalance() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      // Busca TODAS as transações do usuário (receitas e despesas)
      final response = await _supabase
          .from('transactions')
          .select('valor, tipo')
          .eq('usuario_id', userId)
          .order('data', ascending: false);

      double balance = 0.0;
      
      for (var transaction in response) {
        final valor = (transaction['valor'] as num).toDouble();
        final tipo = transaction['tipo'] as String;
        
        if (tipo == 'receita') {
          balance += valor;
        } else if (tipo == 'despesa') {
          balance -= valor;
        }
      }

      return balance;
    } catch (e) {
      throw Exception('Erro ao buscar saldo atual: $e');
    }
  }

  /// Calcula a média de gastos diários dos últimos 30 dias
  Future<double> getAverageDailyExpense() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Busca apenas DESPESAS dos últimos 30 dias
      final response = await _supabase
          .from('transactions')
          .select('valor, data')
          .eq('usuario_id', userId)
          .eq('tipo', 'despesa')
          .gte('data', thirtyDaysAgo.toIso8601String());

      if (response.isEmpty) {
        return 0.0; // Se não há despesas, retorna 0
      }

      // Soma total das despesas
      double totalExpenses = 0.0;
      for (var transaction in response) {
        totalExpenses += (transaction['valor'] as num).toDouble();
      }

      // Média diária = total / 30 dias
      return totalExpenses / 30;
    } catch (e) {
      throw Exception('Erro ao calcular média de gastos: $e');
    }
  }

  /// Gera projeção linear para 90 dias
  /// Fórmula: SaldoFuturo = SaldoAtual - (MédiaDiária × DiasFuturos)
  Future<List<ProjectionPoint>> generate90DayProjection() async {
    try {
      final currentBalance = await getCurrentBalance();
      final avgDailyExpense = await getAverageDailyExpense();

      final List<ProjectionPoint> points = [];
      final now = DateTime.now();

      // Gera 91 pontos (dia 0 até dia 90)
      for (int day = 0; day <= 90; day++) {
        final date = now.add(Duration(days: day));
        final projectedBalance = currentBalance - (avgDailyExpense * day);
        
        points.add(ProjectionPoint(
          date: date,
          balance: projectedBalance,
        ));
      }

      return points;
    } catch (e) {
      throw Exception('Erro ao gerar projeção: $e');
    }
  }

  /// [OPCIONAL] Método auxiliar para debug
  Future<Map<String, dynamic>> getProjectionMetadata() async {
    final currentBalance = await getCurrentBalance();
    final avgDailyExpense = await getAverageDailyExpense();
    final projectedBalanceIn90Days = currentBalance - (avgDailyExpense * 90);
    
    return {
      'currentBalance': currentBalance,
      'avgDailyExpense': avgDailyExpense,
      'projectedBalanceIn90Days': projectedBalanceIn90Days,
      'daysUntilZero': avgDailyExpense > 0 
          ? (currentBalance / avgDailyExpense).round() 
          : null,
    };
  }
}