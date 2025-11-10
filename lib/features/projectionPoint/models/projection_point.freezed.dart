// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projection_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectionPoint _$ProjectionPointFromJson(Map<String, dynamic> json) {
  return _ProjectionPoint.fromJson(json);
}

/// @nodoc
mixin _$ProjectionPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this ProjectionPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectionPointCopyWith<ProjectionPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectionPointCopyWith<$Res> {
  factory $ProjectionPointCopyWith(
          ProjectionPoint value, $Res Function(ProjectionPoint) then) =
      _$ProjectionPointCopyWithImpl<$Res, ProjectionPoint>;
  @useResult
  $Res call({DateTime date, double balance});
}

/// @nodoc
class _$ProjectionPointCopyWithImpl<$Res, $Val extends ProjectionPoint>
    implements $ProjectionPointCopyWith<$Res> {
  _$ProjectionPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectionPointImplCopyWith<$Res>
    implements $ProjectionPointCopyWith<$Res> {
  factory _$$ProjectionPointImplCopyWith(_$ProjectionPointImpl value,
          $Res Function(_$ProjectionPointImpl) then) =
      __$$ProjectionPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double balance});
}

/// @nodoc
class __$$ProjectionPointImplCopyWithImpl<$Res>
    extends _$ProjectionPointCopyWithImpl<$Res, _$ProjectionPointImpl>
    implements _$$ProjectionPointImplCopyWith<$Res> {
  __$$ProjectionPointImplCopyWithImpl(
      _$ProjectionPointImpl _value, $Res Function(_$ProjectionPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? balance = null,
  }) {
    return _then(_$ProjectionPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectionPointImpl implements _ProjectionPoint {
  const _$ProjectionPointImpl({required this.date, required this.balance});

  factory _$ProjectionPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectionPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double balance;

  @override
  String toString() {
    return 'ProjectionPoint(date: $date, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectionPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, balance);

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectionPointImplCopyWith<_$ProjectionPointImpl> get copyWith =>
      __$$ProjectionPointImplCopyWithImpl<_$ProjectionPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectionPointImplToJson(
      this,
    );
  }
}

abstract class _ProjectionPoint implements ProjectionPoint {
  const factory _ProjectionPoint(
      {required final DateTime date,
      required final double balance}) = _$ProjectionPointImpl;

  factory _ProjectionPoint.fromJson(Map<String, dynamic> json) =
      _$ProjectionPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get balance;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectionPointImplCopyWith<_$ProjectionPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
