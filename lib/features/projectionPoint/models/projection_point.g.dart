// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectionPointImpl _$$ProjectionPointImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectionPointImpl(
      date: DateTime.parse(json['date'] as String),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProjectionPointImplToJson(
        _$ProjectionPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'balance': instance.balance,
    };
