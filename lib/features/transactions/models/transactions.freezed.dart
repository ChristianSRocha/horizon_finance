// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
// Nomes do JSON (supabase) para os nomes do Dart
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id')
  String get usuarioId => throw _privateConstructorUsedError;
  TransactionType get tipo => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  double get valor => throw _privateConstructorUsedError;
  @JsonKey(name: 'dia_do_mes')
  int? get diaDoMes => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  DateTime? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoria_id')
  int? get categoriaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fixed_transaction')
  bool get fixedTransaction => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_id')
  String? get templateId => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      TransactionType tipo,
      String descricao,
      double valor,
      @JsonKey(name: 'dia_do_mes') int? diaDoMes,
      @JsonKey(name: 'data') DateTime? data,
      @JsonKey(name: 'categoria_id') int? categoriaId,
      @JsonKey(name: 'fixed_transaction') bool fixedTransaction,
      @JsonKey(name: 'template_id') String? templateId,
      TransactionStatus status,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? tipo = null,
    Object? descricao = null,
    Object? valor = null,
    Object? diaDoMes = freezed,
    Object? data = freezed,
    Object? categoriaId = freezed,
    Object? fixedTransaction = null,
    Object? templateId = freezed,
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
      diaDoMes: freezed == diaDoMes
          ? _value.diaDoMes
          : diaDoMes // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoriaId: freezed == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int?,
      fixedTransaction: null == fixedTransaction
          ? _value.fixedTransaction
          : fixedTransaction // ignore: cast_nullable_to_non_nullable
              as bool,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      TransactionType tipo,
      String descricao,
      double valor,
      @JsonKey(name: 'dia_do_mes') int? diaDoMes,
      @JsonKey(name: 'data') DateTime? data,
      @JsonKey(name: 'categoria_id') int? categoriaId,
      @JsonKey(name: 'fixed_transaction') bool fixedTransaction,
      @JsonKey(name: 'template_id') String? templateId,
      TransactionStatus status,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? tipo = null,
    Object? descricao = null,
    Object? valor = null,
    Object? diaDoMes = freezed,
    Object? data = freezed,
    Object? categoriaId = freezed,
    Object? fixedTransaction = null,
    Object? templateId = freezed,
    Object? status = null,
    Object? dataCriacao = null,
  }) {
    return _then(_$TransactionImpl(
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
      diaDoMes: freezed == diaDoMes
          ? _value.diaDoMes
          : diaDoMes // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoriaId: freezed == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int?,
      fixedTransaction: null == fixedTransaction
          ? _value.fixedTransaction
          : fixedTransaction // ignore: cast_nullable_to_non_nullable
              as bool,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.id,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      required this.tipo,
      required this.descricao,
      required this.valor,
      @JsonKey(name: 'dia_do_mes') this.diaDoMes,
      @JsonKey(name: 'data') this.data,
      @JsonKey(name: 'categoria_id') this.categoriaId,
      @JsonKey(name: 'fixed_transaction') this.fixedTransaction = false,
      @JsonKey(name: 'template_id') this.templateId,
      required this.status,
      @JsonKey(name: 'data_criacao') required this.dataCriacao});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

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
  final int? diaDoMes;
  @override
  @JsonKey(name: 'data')
  final DateTime? data;
  @override
  @JsonKey(name: 'categoria_id')
  final int? categoriaId;
  @override
  @JsonKey(name: 'fixed_transaction')
  final bool fixedTransaction;
  @override
  @JsonKey(name: 'template_id')
  final String? templateId;
  @override
  final TransactionStatus status;
  @override
  @JsonKey(name: 'data_criacao')
  final DateTime dataCriacao;

  @override
  String toString() {
    return 'Transaction(id: $id, usuarioId: $usuarioId, tipo: $tipo, descricao: $descricao, valor: $valor, diaDoMes: $diaDoMes, data: $data, categoriaId: $categoriaId, fixedTransaction: $fixedTransaction, templateId: $templateId, status: $status, dataCriacao: $dataCriacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.diaDoMes, diaDoMes) ||
                other.diaDoMes == diaDoMes) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.categoriaId, categoriaId) ||
                other.categoriaId == categoriaId) &&
            (identical(other.fixedTransaction, fixedTransaction) ||
                other.fixedTransaction == fixedTransaction) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      usuarioId,
      tipo,
      descricao,
      valor,
      diaDoMes,
      data,
      categoriaId,
      fixedTransaction,
      templateId,
      status,
      dataCriacao);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
          {required final String id,
          @JsonKey(name: 'usuario_id') required final String usuarioId,
          required final TransactionType tipo,
          required final String descricao,
          required final double valor,
          @JsonKey(name: 'dia_do_mes') final int? diaDoMes,
          @JsonKey(name: 'data') final DateTime? data,
          @JsonKey(name: 'categoria_id') final int? categoriaId,
          @JsonKey(name: 'fixed_transaction') final bool fixedTransaction,
          @JsonKey(name: 'template_id') final String? templateId,
          required final TransactionStatus status,
          @JsonKey(name: 'data_criacao') required final DateTime dataCriacao}) =
      _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

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
  int? get diaDoMes;
  @override
  @JsonKey(name: 'data')
  DateTime? get data;
  @override
  @JsonKey(name: 'categoria_id')
  int? get categoriaId;
  @override
  @JsonKey(name: 'fixed_transaction')
  bool get fixedTransaction;
  @override
  @JsonKey(name: 'template_id')
  String? get templateId;
  @override
  TransactionStatus get status;
  @override
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
