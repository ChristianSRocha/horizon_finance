// lib/features/transactions/models/transactions.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions.freezed.dart';
part 'transactions.g.dart';

enum TransactionType {
  @JsonValue('RECEITA')
  receita,
  @JsonValue('DESPESA')
  despesa,
}

enum TransactionStatus {
  @JsonValue('ATIVO')
  ativo,
  @JsonValue('INATIVO')
  inativo,
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    // Nomes do JSON (supabase) para os nomes do Dart
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    required TransactionType tipo,
    required String descricao,
    required double valor,
    @JsonKey(name: 'dia_do_mes') int? diaDoMes,
    @JsonKey(name: 'data') DateTime? data,
    @JsonKey(name: 'categoria_id') int? categoriaId, 
    @Default(false)
    @JsonKey(name: 'fixed_transaction') bool fixedTransaction,
    @JsonKey(name: 'template_id') String? templateId,
    required TransactionStatus status,
    
    @JsonKey(name: 'data_criacao') required DateTime dataCriacao,

  }) = _Transaction;

  // 7 factory 'fromJson' para desserialização
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}