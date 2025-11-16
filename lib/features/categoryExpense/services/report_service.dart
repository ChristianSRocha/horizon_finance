import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_expense.dart';

class ReportService {
  final SupabaseClient supabase;

  ReportService(this.supabase);

  Future<List<CategoryExpense>> getExpensesByCategory({
    required int year,
    required int month,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    // DEFINIR INÍCIO E FIM DO MÊS
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1).subtract(const Duration(seconds: 1));

    // BUSCAR TODAS AS DESPESAS
    final result = await supabase
        .from("transactions")
        .select("""
          id,
          valor,
          tipo,
          data,
          dia_do_mes,
          fixed_transaction,
          categoria_id,
          data_criacao,
          categories (nome, tipo)
        """)
        .eq("usuario_id", user.id)
        .eq("tipo", "DESPESA")
        .eq("status", "ATIVO");

    final List data = result;

    // AGRUPAMENTO POR CATEGORIA
    final Map<String, double> grouped = {};

    // Para evitar duplicatas de despesas fixas, rastrear por ID único
    final Set<String> processedExpenseIds = {};

    for (final row in data) {
      try {
        final cat = row["categories"];
        if (cat == null || cat["tipo"] != "DESPESA") continue;

        final expenseId = row["id"] as String;
        
        // Se já processamos esta despesa específica, pular
        if (processedExpenseIds.contains(expenseId)) {
          continue;
        }

        DateTime? eventDate;

        // Despesa variável (com data específica)
        if (row["data"] != null) {
          eventDate = DateTime.parse(row["data"] as String);
        }
        // Despesa fixa (com dia do mês recorrente)
        else if (row["dia_do_mes"] != null) {
          final diaDoMes = row["dia_do_mes"] as int;
          eventDate = DateTime(year, month, diaDoMes);
        }

        // Se não tem data nem dia_do_mes, ignorar
        if (eventDate == null) continue;

        // Filtrar pelo mês selecionado
        if (eventDate.isBefore(startDate) || eventDate.isAfter(endDate)) {
          continue;
        }

        // Marcar como processado
        processedExpenseIds.add(expenseId);

        final value = (row["valor"] as num).toDouble();
        final categoryName = cat["nome"] as String;

        // Somar os valores por categoria (todas as despesas, fixas ou não)
        grouped[categoryName] = (grouped[categoryName] ?? 0) + value;
        
      } catch (e) {
        print('Erro ao processar transação: $e');
        print('Dados da transação: $row');
        continue;
      }
    }

    // Converter para lista e ordenar por valor (maior primeiro)
    final expenses = grouped.entries
        .map(
          (e) => CategoryExpense(
            category: e.key,
            totalAmount: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return expenses;
  }
}