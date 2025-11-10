// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectionStateImpl _$$ProjectionStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectionStateImpl(
      isLoading: json['isLoading'] as bool? ?? false,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => ProjectionPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$ProjectionStateImplToJson(
        _$ProjectionStateImpl instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'points': instance.points,
      'errorMessage': instance.errorMessage,
    };
