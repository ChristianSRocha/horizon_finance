// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryExpense _$CategoryExpenseFromJson(Map<String, dynamic> json) {
  return _CategoryExpense.fromJson(json);
}

/// @nodoc
mixin _$CategoryExpense {
  String get category => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;

  /// Serializes this CategoryExpense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryExpenseCopyWith<CategoryExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryExpenseCopyWith<$Res> {
  factory $CategoryExpenseCopyWith(
          CategoryExpense value, $Res Function(CategoryExpense) then) =
      _$CategoryExpenseCopyWithImpl<$Res, CategoryExpense>;
  @useResult
  $Res call({String category, double totalAmount});
}

/// @nodoc
class _$CategoryExpenseCopyWithImpl<$Res, $Val extends CategoryExpense>
    implements $CategoryExpenseCopyWith<$Res> {
  _$CategoryExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalAmount = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryExpenseImplCopyWith<$Res>
    implements $CategoryExpenseCopyWith<$Res> {
  factory _$$CategoryExpenseImplCopyWith(_$CategoryExpenseImpl value,
          $Res Function(_$CategoryExpenseImpl) then) =
      __$$CategoryExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, double totalAmount});
}

/// @nodoc
class __$$CategoryExpenseImplCopyWithImpl<$Res>
    extends _$CategoryExpenseCopyWithImpl<$Res, _$CategoryExpenseImpl>
    implements _$$CategoryExpenseImplCopyWith<$Res> {
  __$$CategoryExpenseImplCopyWithImpl(
      _$CategoryExpenseImpl _value, $Res Function(_$CategoryExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalAmount = null,
  }) {
    return _then(_$CategoryExpenseImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryExpenseImpl implements _CategoryExpense {
  const _$CategoryExpenseImpl(
      {required this.category, required this.totalAmount});

  factory _$CategoryExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryExpenseImplFromJson(json);

  @override
  final String category;
  @override
  final double totalAmount;

  @override
  String toString() {
    return 'CategoryExpense(category: $category, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryExpenseImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, totalAmount);

  /// Create a copy of CategoryExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryExpenseImplCopyWith<_$CategoryExpenseImpl> get copyWith =>
      __$$CategoryExpenseImplCopyWithImpl<_$CategoryExpenseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryExpenseImplToJson(
      this,
    );
  }
}

abstract class _CategoryExpense implements CategoryExpense {
  const factory _CategoryExpense(
      {required final String category,
      required final double totalAmount}) = _$CategoryExpenseImpl;

  factory _CategoryExpense.fromJson(Map<String, dynamic> json) =
      _$CategoryExpenseImpl.fromJson;

  @override
  String get category;
  @override
  double get totalAmount;

  /// Create a copy of CategoryExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryExpenseImplCopyWith<_$CategoryExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
