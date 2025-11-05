// lib/features/transactions/models/transactions.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions.freezed.dart';
part 'transactions.g.dart';


@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    // Nomes do JSON (supabase) para os nomes do Dart
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    required TransactionType tipo,
    required String descricao,
    required double valor,
    required string TransactionType,
    required string TransactionStatus,
    @JsonKey(name: 'dia_do_mes') int? diaDoMes,
    @JsonKey(name: 'data') DateTime? data,
    @JsonKey(name: 'categoria_id') int? categoriaId, 
    @JsonKey(name: 'fixed_transaction') required bool fixedTransaction,
    
    required TransactionStatus status,
    
    @JsonKey(name: 'data_criacao') required DateTime dataCriacao,

  }) = _Transaction;

  // 7. Adicione o factory 'fromJson' para desserialização
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}