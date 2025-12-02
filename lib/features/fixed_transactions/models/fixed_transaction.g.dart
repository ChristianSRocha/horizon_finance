// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FixedTransactionImpl _$$FixedTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$FixedTransactionImpl(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      tipo: $enumDecode(_$TransactionTypeEnumMap, json['tipo']),
      categoriaId: (json['categoria_id'] as num).toInt(),
      diaDoMes: (json['dia_do_mes'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
      ultimaGeracao: json['ultima_geracao'] == null
          ? null
          : DateTime.parse(json['ultima_geracao'] as String),
    );

Map<String, dynamic> _$$FixedTransactionImplToJson(
        _$FixedTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'descricao': instance.descricao,
      'valor': instance.valor,
      'tipo': _$TransactionTypeEnumMap[instance.tipo]!,
      'categoria_id': instance.categoriaId,
      'dia_do_mes': instance.diaDoMes,
      'is_active': instance.isActive,
      'data_criacao': instance.dataCriacao.toIso8601String(),
      'ultima_geracao': instance.ultimaGeracao?.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.receita: 'RECEITA',
  TransactionType.despesa: 'DESPESA',
};
