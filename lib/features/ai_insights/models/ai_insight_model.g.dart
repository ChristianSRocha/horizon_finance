// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIInsightModelImpl _$$AIInsightModelImplFromJson(Map<String, dynamic> json) =>
    _$AIInsightModelImpl(
      insights:
          (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$AIInsightModelImplToJson(
        _$AIInsightModelImpl instance) =>
    <String, dynamic>{
      'insights': instance.insights,
    };
