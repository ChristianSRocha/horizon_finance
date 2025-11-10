// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectionState _$ProjectionStateFromJson(Map<String, dynamic> json) {
  return _ProjectionState.fromJson(json);
}

/// @nodoc
mixin _$ProjectionState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<ProjectionPoint> get points => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this ProjectionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectionStateCopyWith<ProjectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectionStateCopyWith<$Res> {
  factory $ProjectionStateCopyWith(
          ProjectionState value, $Res Function(ProjectionState) then) =
      _$ProjectionStateCopyWithImpl<$Res, ProjectionState>;
  @useResult
  $Res call(
      {bool isLoading, List<ProjectionPoint> points, String? errorMessage});
}

/// @nodoc
class _$ProjectionStateCopyWithImpl<$Res, $Val extends ProjectionState>
    implements $ProjectionStateCopyWith<$Res> {
  _$ProjectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? points = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<ProjectionPoint>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectionStateImplCopyWith<$Res>
    implements $ProjectionStateCopyWith<$Res> {
  factory _$$ProjectionStateImplCopyWith(_$ProjectionStateImpl value,
          $Res Function(_$ProjectionStateImpl) then) =
      __$$ProjectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, List<ProjectionPoint> points, String? errorMessage});
}

/// @nodoc
class __$$ProjectionStateImplCopyWithImpl<$Res>
    extends _$ProjectionStateCopyWithImpl<$Res, _$ProjectionStateImpl>
    implements _$$ProjectionStateImplCopyWith<$Res> {
  __$$ProjectionStateImplCopyWithImpl(
      _$ProjectionStateImpl _value, $Res Function(_$ProjectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? points = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ProjectionStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<ProjectionPoint>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectionStateImpl implements _ProjectionState {
  const _$ProjectionStateImpl(
      {this.isLoading = false,
      final List<ProjectionPoint> points = const [],
      this.errorMessage})
      : _points = points;

  factory _$ProjectionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectionStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isLoading;
  final List<ProjectionPoint> _points;
  @override
  @JsonKey()
  List<ProjectionPoint> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ProjectionState(isLoading: $isLoading, points: $points, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectionStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_points), errorMessage);

  /// Create a copy of ProjectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectionStateImplCopyWith<_$ProjectionStateImpl> get copyWith =>
      __$$ProjectionStateImplCopyWithImpl<_$ProjectionStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectionStateImplToJson(
      this,
    );
  }
}

abstract class _ProjectionState implements ProjectionState {
  const factory _ProjectionState(
      {final bool isLoading,
      final List<ProjectionPoint> points,
      final String? errorMessage}) = _$ProjectionStateImpl;

  factory _ProjectionState.fromJson(Map<String, dynamic> json) =
      _$ProjectionStateImpl.fromJson;

  @override
  bool get isLoading;
  @override
  List<ProjectionPoint> get points;
  @override
  String? get errorMessage;

  /// Create a copy of ProjectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectionStateImplCopyWith<_$ProjectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
