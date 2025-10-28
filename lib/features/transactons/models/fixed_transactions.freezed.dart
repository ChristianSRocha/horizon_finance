// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FixedTransaction _$FixedTransactionFromJson(Map<String, dynamic> json) {
  return _FixedTransaction.fromJson(json);
}

/// @nodoc
mixin _$FixedTransaction {
// Nomes do JSON (supabase) para os nomes do Dart
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id')
  String get usuarioId => throw _privateConstructorUsedError;
  TransactionType get tipo => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  double get valor => throw _privateConstructorUsedError;
  @JsonKey(name: 'dia_do_mes')
  int get dia => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoria_id')
  int? get categoriaId => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao => throw _privateConstructorUsedError;

  /// Serializes this FixedTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedTransactionCopyWith<FixedTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedTransactionCopyWith<$Res> {
  factory $FixedTransactionCopyWith(
          FixedTransaction value, $Res Function(FixedTransaction) then) =
      _$FixedTransactionCopyWithImpl<$Res, FixedTransaction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      TransactionType tipo,
      String descricao,
      double valor,
      @JsonKey(name: 'dia_do_mes') int dia,
      @JsonKey(name: 'categoria_id') int? categoriaId,
      TransactionStatus status,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao});
}

/// @nodoc
class _$FixedTransactionCopyWithImpl<$Res, $Val extends FixedTransaction>
    implements $FixedTransactionCopyWith<$Res> {
  _$FixedTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? tipo = null,
    Object? descricao = null,
    Object? valor = null,
    Object? dia = null,
    Object? categoriaId = freezed,
    Object? status = null,
    Object? dataCriacao = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      descricao: null == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String,
      valor: null == valor
          ? _value.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as double,
      dia: null == dia
          ? _value.dia
          : dia // ignore: cast_nullable_to_non_nullable
              as int,
      categoriaId: freezed == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FixedTransactionImplCopyWith<$Res>
    implements $FixedTransactionCopyWith<$Res> {
  factory _$$FixedTransactionImplCopyWith(_$FixedTransactionImpl value,
          $Res Function(_$FixedTransactionImpl) then) =
      __$$FixedTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      TransactionType tipo,
      String descricao,
      double valor,
      @JsonKey(name: 'dia_do_mes') int dia,
      @JsonKey(name: 'categoria_id') int? categoriaId,
      TransactionStatus status,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao});
}

/// @nodoc
class __$$FixedTransactionImplCopyWithImpl<$Res>
    extends _$FixedTransactionCopyWithImpl<$Res, _$FixedTransactionImpl>
    implements _$$FixedTransactionImplCopyWith<$Res> {
  __$$FixedTransactionImplCopyWithImpl(_$FixedTransactionImpl _value,
      $Res Function(_$FixedTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? tipo = null,
    Object? descricao = null,
    Object? valor = null,
    Object? dia = null,
    Object? categoriaId = freezed,
    Object? status = null,
    Object? dataCriacao = null,
  }) {
    return _then(_$FixedTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      descricao: null == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String,
      valor: null == valor
          ? _value.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as double,
      dia: null == dia
          ? _value.dia
          : dia // ignore: cast_nullable_to_non_nullable
              as int,
      categoriaId: freezed == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedTransactionImpl implements _FixedTransaction {
  const _$FixedTransactionImpl(
      {required this.id,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      required this.tipo,
      required this.descricao,
      required this.valor,
      @JsonKey(name: 'dia_do_mes') required this.dia,
      @JsonKey(name: 'categoria_id') this.categoriaId,
      required this.status,
      @JsonKey(name: 'data_criacao') required this.dataCriacao});

  factory _$FixedTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedTransactionImplFromJson(json);

// Nomes do JSON (supabase) para os nomes do Dart
  @override
  final String id;
  @override
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @override
  final TransactionType tipo;
  @override
  final String descricao;
  @override
  final double valor;
  @override
  @JsonKey(name: 'dia_do_mes')
  final int dia;
  @override
  @JsonKey(name: 'categoria_id')
  final int? categoriaId;
  @override
  final TransactionStatus status;
  @override
  @JsonKey(name: 'data_criacao')
  final DateTime dataCriacao;

  @override
  String toString() {
    return 'FixedTransaction(id: $id, usuarioId: $usuarioId, tipo: $tipo, descricao: $descricao, valor: $valor, dia: $dia, categoriaId: $categoriaId, status: $status, dataCriacao: $dataCriacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.categoriaId, categoriaId) ||
                other.categoriaId == categoriaId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, usuarioId, tipo, descricao,
      valor, dia, categoriaId, status, dataCriacao);

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedTransactionImplCopyWith<_$FixedTransactionImpl> get copyWith =>
      __$$FixedTransactionImplCopyWithImpl<_$FixedTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedTransactionImplToJson(
      this,
    );
  }
}

abstract class _FixedTransaction implements FixedTransaction {
  const factory _FixedTransaction(
          {required final String id,
          @JsonKey(name: 'usuario_id') required final String usuarioId,
          required final TransactionType tipo,
          required final String descricao,
          required final double valor,
          @JsonKey(name: 'dia_do_mes') required final int dia,
          @JsonKey(name: 'categoria_id') final int? categoriaId,
          required final TransactionStatus status,
          @JsonKey(name: 'data_criacao') required final DateTime dataCriacao}) =
      _$FixedTransactionImpl;

  factory _FixedTransaction.fromJson(Map<String, dynamic> json) =
      _$FixedTransactionImpl.fromJson;

// Nomes do JSON (supabase) para os nomes do Dart
  @override
  String get id;
  @override
  @JsonKey(name: 'usuario_id')
  String get usuarioId;
  @override
  TransactionType get tipo;
  @override
  String get descricao;
  @override
  double get valor;
  @override
  @JsonKey(name: 'dia_do_mes')
  int get dia;
  @override
  @JsonKey(name: 'categoria_id')
  int? get categoriaId;
  @override
  TransactionStatus get status;
  @override
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao;

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedTransactionImplCopyWith<_$FixedTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
