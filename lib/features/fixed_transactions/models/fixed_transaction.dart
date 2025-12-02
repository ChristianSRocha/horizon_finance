// lib/features/fixed_transactions/models/fixed_transaction.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';

part 'fixed_transaction.freezed.dart';
part 'fixed_transaction.g.dart';

/// Modelo para transações fixas/recorrentes
/// Representa uma "regra" que gera transações automaticamente
@freezed
class FixedTransaction with _$FixedTransaction {

  const FixedTransaction._();

  
  const factory FixedTransaction({
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    required String descricao,
    required double valor,
    required TransactionType tipo,
    @JsonKey(name: 'categoria_id') required int categoriaId,
    
    /// Dia do mês que a transação deve ser lançada (1-31)
    @JsonKey(name: 'dia_do_mes') required int diaDoMes,
    
    /// Indica se a recorrência está ativa
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    
    /// Data de criação do template
    @JsonKey(name: 'data_criacao') required DateTime dataCriacao,
    
    /// Data da última vez que uma transação foi gerada (opcional)
    @JsonKey(name: 'ultima_geracao') DateTime? ultimaGeracao,
  }) = _FixedTransaction;

  factory FixedTransaction.fromJson(Map<String, dynamic> json) =>
      _$FixedTransactionFromJson(json);

  /// Verifica se deve gerar transação para o dia fornecido
  bool shouldGenerateFor(DateTime date) {
    if (!isActive) return false;
    
    // Obtém o dia real de vencimento considerando o último dia do mês
    final effectiveDueDay = getEffectiveDueDay(date);
    
    return date.day == effectiveDueDay;
  }
  
  /// Calcula o dia efetivo considerando meses com menos dias
  /// Ex: Se diaDoMes = 31 mas fevereiro só tem 28, retorna 28
  int getEffectiveDueDay(DateTime date) {
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;
    return diaDoMes > lastDayOfMonth ? lastDayOfMonth : diaDoMes;
  }
  
  /// Verifica se já foi gerada uma transação neste mês/ano
  bool wasGeneratedThisMonth(DateTime date, DateTime? ultimaGeracao) {
    if (ultimaGeracao == null) return false;
    
    return ultimaGeracao.year == date.year && 
           ultimaGeracao.month == date.month;
  }
  
  /// Converte para uma Transaction comum
  Transaction toTransaction(DateTime date) {
    return Transaction(
      id: '', // Será gerado pelo banco
      usuarioId: usuarioId,
      tipo: tipo,
      descricao: descricao,
      valor: valor,
      categoriaId: categoriaId,
      data: DateTime(
        date.year,
        date.month,
        getEffectiveDueDay(date),
      ),
      diaDoMes: null,
      fixedTransaction: false, // A transação gerada é uma transação comum
      status: TransactionStatus.ativo,
      dataCriacao: DateTime.now(),
    );
  }
}

