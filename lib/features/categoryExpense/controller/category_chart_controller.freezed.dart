// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_chart_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoryChartState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<CategoryExpense> get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CategoryChartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryChartStateCopyWith<CategoryChartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryChartStateCopyWith<$Res> {
  factory $CategoryChartStateCopyWith(
          CategoryChartState value, $Res Function(CategoryChartState) then) =
      _$CategoryChartStateCopyWithImpl<$Res, CategoryChartState>;
  @useResult
  $Res call({bool isLoading, List<CategoryExpense> data, String? error});
}

/// @nodoc
class _$CategoryChartStateCopyWithImpl<$Res, $Val extends CategoryChartState>
    implements $CategoryChartStateCopyWith<$Res> {
  _$CategoryChartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryChartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<CategoryExpense>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryChartStateImplCopyWith<$Res>
    implements $CategoryChartStateCopyWith<$Res> {
  factory _$$CategoryChartStateImplCopyWith(_$CategoryChartStateImpl value,
          $Res Function(_$CategoryChartStateImpl) then) =
      __$$CategoryChartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<CategoryExpense> data, String? error});
}

/// @nodoc
class __$$CategoryChartStateImplCopyWithImpl<$Res>
    extends _$CategoryChartStateCopyWithImpl<$Res, _$CategoryChartStateImpl>
    implements _$$CategoryChartStateImplCopyWith<$Res> {
  __$$CategoryChartStateImplCopyWithImpl(_$CategoryChartStateImpl _value,
      $Res Function(_$CategoryChartStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryChartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(_$CategoryChartStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<CategoryExpense>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CategoryChartStateImpl implements _CategoryChartState {
  const _$CategoryChartStateImpl(
      {this.isLoading = false,
      final List<CategoryExpense> data = const [],
      this.error})
      : _data = data;

  @override
  @JsonKey()
  final bool isLoading;
  final List<CategoryExpense> _data;
  @override
  @JsonKey()
  List<CategoryExpense> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'CategoryChartState(isLoading: $isLoading, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryChartStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_data), error);

  /// Create a copy of CategoryChartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryChartStateImplCopyWith<_$CategoryChartStateImpl> get copyWith =>
      __$$CategoryChartStateImplCopyWithImpl<_$CategoryChartStateImpl>(
          this, _$identity);
}

abstract class _CategoryChartState implements CategoryChartState {
  const factory _CategoryChartState(
      {final bool isLoading,
      final List<CategoryExpense> data,
      final String? error}) = _$CategoryChartStateImpl;

  @override
  bool get isLoading;
  @override
  List<CategoryExpense> get data;
  @override
  String? get error;

  /// Create a copy of CategoryChartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryChartStateImplCopyWith<_$CategoryChartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
