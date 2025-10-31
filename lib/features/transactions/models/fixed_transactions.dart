// lib/features/transactions/models/fixed_transactions.dart

import 'package:freezed_annotation/freezed_annotation.dart';


part 'fixed_transactions.freezed.dart';
part 'fixed_transactions.g.dart';

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
class FixedTransaction with _$FixedTransaction {
  const factory FixedTransaction({
    // Nomes do JSON (supabase) para os nomes do Dart
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    required TransactionType tipo,
    required String descricao,
    required double valor,
    @JsonKey(name: 'dia_do_mes') required int dia,
    @JsonKey(name: 'categoria_id') int? categoriaId, 
    
    required TransactionStatus status,
    
    @JsonKey(name: 'data_criacao') required DateTime dataCriacao,

  }) = _FixedTransaction;

  // 7. Adicione o factory 'fromJson' para desserialização
  factory FixedTransaction.fromJson(Map<String, dynamic> json) =>
      _$FixedTransactionFromJson(json);
}