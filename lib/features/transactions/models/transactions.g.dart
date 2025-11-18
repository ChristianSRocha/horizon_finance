// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: $enumDecode(_$TransactionTypeEnumMap, json['tipo']),
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      diaDoMes: (json['dia_do_mes'] as num?)?.toInt(),
      data:
          json['data'] == null ? null : DateTime.parse(json['data'] as String),
      categoriaId: (json['categoria_id'] as num?)?.toInt(),
      fixedTransaction: json['fixed_transaction'] as bool? ?? false,
      templateId: json['template_id'] as String?,
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'tipo': _$TransactionTypeEnumMap[instance.tipo]!,
      'descricao': instance.descricao,
      'valor': instance.valor,
      'dia_do_mes': instance.diaDoMes,
      'data': instance.data?.toIso8601String(),
      'categoria_id': instance.categoriaId,
      'fixed_transaction': instance.fixedTransaction,
      'template_id': instance.templateId,
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
