// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FixedTransactionImpl _$$FixedTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$FixedTransactionImpl(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: $enumDecode(_$TransactionTypeEnumMap, json['tipo']),
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      dia: (json['dia_do_mes'] as num).toInt(),
      categoriaId: (json['categoria_id'] as num?)?.toInt(),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
    );

Map<String, dynamic> _$$FixedTransactionImplToJson(
        _$FixedTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'tipo': _$TransactionTypeEnumMap[instance.tipo]!,
      'descricao': instance.descricao,
      'valor': instance.valor,
      'dia_do_mes': instance.dia,
      'categoria_id': instance.categoriaId,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'data_criacao': instance.dataCriacao.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.receita: 'RECEITA',
  TransactionType.despesa: 'DESPESA',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.ativo: 'ATIVO',
  TransactionStatus.inativo: 'INATIVO',
};
