// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      nome: json['nome'] as String,
      valorTotal: (json['valor_total'] as num).toDouble(),
      valorAtual: (json['valor_atual'] as num).toDouble(),
      dataFinal: json['data_final'] == null
          ? null
          : DateTime.parse(json['data_final'] as String),
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
    );

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'nome': instance.nome,
      'valor_total': instance.valorTotal,
      'valor_atual': instance.valorAtual,
      'data_final': instance.dataFinal?.toIso8601String(),
      'data_criacao': instance.dataCriacao.toIso8601String(),
    };
