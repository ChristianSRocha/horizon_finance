// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryExpenseImpl _$$CategoryExpenseImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryExpenseImpl(
      category: json['category'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$CategoryExpenseImplToJson(
        _$CategoryExpenseImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'totalAmount': instance.totalAmount,
    };
