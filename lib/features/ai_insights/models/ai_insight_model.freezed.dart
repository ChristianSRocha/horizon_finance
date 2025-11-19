// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_insight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIInsightModel _$AIInsightModelFromJson(Map<String, dynamic> json) {
  return _AIInsightModel.fromJson(json);
}

/// @nodoc
mixin _$AIInsightModel {
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this AIInsightModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIInsightModelCopyWith<AIInsightModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIInsightModelCopyWith<$Res> {
  factory $AIInsightModelCopyWith(
          AIInsightModel value, $Res Function(AIInsightModel) then) =
      _$AIInsightModelCopyWithImpl<$Res, AIInsightModel>;
  @useResult
  $Res call({List<String> insights});
}

/// @nodoc
class _$AIInsightModelCopyWithImpl<$Res, $Val extends AIInsightModel>
    implements $AIInsightModelCopyWith<$Res> {
  _$AIInsightModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIInsightModelImplCopyWith<$Res>
    implements $AIInsightModelCopyWith<$Res> {
  factory _$$AIInsightModelImplCopyWith(_$AIInsightModelImpl value,
          $Res Function(_$AIInsightModelImpl) then) =
      __$$AIInsightModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> insights});
}

/// @nodoc
class __$$AIInsightModelImplCopyWithImpl<$Res>
    extends _$AIInsightModelCopyWithImpl<$Res, _$AIInsightModelImpl>
    implements _$$AIInsightModelImplCopyWith<$Res> {
  __$$AIInsightModelImplCopyWithImpl(
      _$AIInsightModelImpl _value, $Res Function(_$AIInsightModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
  }) {
    return _then(_$AIInsightModelImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIInsightModelImpl implements _AIInsightModel {
  const _$AIInsightModelImpl({required final List<String> insights})
      : _insights = insights;

  factory _$AIInsightModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIInsightModelImplFromJson(json);

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'AIInsightModel(insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIInsightModelImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_insights));

  /// Create a copy of AIInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIInsightModelImplCopyWith<_$AIInsightModelImpl> get copyWith =>
      __$$AIInsightModelImplCopyWithImpl<_$AIInsightModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIInsightModelImplToJson(
      this,
    );
  }
}

abstract class _AIInsightModel implements AIInsightModel {
  const factory _AIInsightModel({required final List<String> insights}) =
      _$AIInsightModelImpl;

  factory _AIInsightModel.fromJson(Map<String, dynamic> json) =
      _$AIInsightModelImpl.fromJson;

  @override
  List<String> get insights;

  /// Create a copy of AIInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIInsightModelImplCopyWith<_$AIInsightModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
