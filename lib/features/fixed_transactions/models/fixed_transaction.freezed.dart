// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_transaction.dart';

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
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id')
  String get usuarioId => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  double get valor => throw _privateConstructorUsedError;
  TransactionType get tipo => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoria_id')
  int get categoriaId => throw _privateConstructorUsedError;

  /// Dia do mês que a transação deve ser lançada (1-31)
  @JsonKey(name: 'dia_do_mes')
  int get diaDoMes => throw _privateConstructorUsedError;

  /// Indica se a recorrência está ativa
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Data de criação do template
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao => throw _privateConstructorUsedError;

  /// Data da última vez que uma transação foi gerada (opcional)
  @JsonKey(name: 'ultima_geracao')
  DateTime? get ultimaGeracao => throw _privateConstructorUsedError;

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
      String descricao,
      double valor,
      TransactionType tipo,
      @JsonKey(name: 'categoria_id') int categoriaId,
      @JsonKey(name: 'dia_do_mes') int diaDoMes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao,
      @JsonKey(name: 'ultima_geracao') DateTime? ultimaGeracao});
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
    Object? descricao = null,
    Object? valor = null,
    Object? tipo = null,
    Object? categoriaId = null,
    Object? diaDoMes = null,
    Object? isActive = null,
    Object? dataCriacao = null,
    Object? ultimaGeracao = freezed,
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
      descricao: null == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String,
      valor: null == valor
          ? _value.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as double,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoriaId: null == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int,
      diaDoMes: null == diaDoMes
          ? _value.diaDoMes
          : diaDoMes // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ultimaGeracao: freezed == ultimaGeracao
          ? _value.ultimaGeracao
          : ultimaGeracao // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      String descricao,
      double valor,
      TransactionType tipo,
      @JsonKey(name: 'categoria_id') int categoriaId,
      @JsonKey(name: 'dia_do_mes') int diaDoMes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'data_criacao') DateTime dataCriacao,
      @JsonKey(name: 'ultima_geracao') DateTime? ultimaGeracao});
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
    Object? descricao = null,
    Object? valor = null,
    Object? tipo = null,
    Object? categoriaId = null,
    Object? diaDoMes = null,
    Object? isActive = null,
    Object? dataCriacao = null,
    Object? ultimaGeracao = freezed,
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
      descricao: null == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String,
      valor: null == valor
          ? _value.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as double,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoriaId: null == categoriaId
          ? _value.categoriaId
          : categoriaId // ignore: cast_nullable_to_non_nullable
              as int,
      diaDoMes: null == diaDoMes
          ? _value.diaDoMes
          : diaDoMes // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ultimaGeracao: freezed == ultimaGeracao
          ? _value.ultimaGeracao
          : ultimaGeracao // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedTransactionImpl extends _FixedTransaction {
  const _$FixedTransactionImpl(
      {required this.id,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      required this.descricao,
      required this.valor,
      required this.tipo,
      @JsonKey(name: 'categoria_id') required this.categoriaId,
      @JsonKey(name: 'dia_do_mes') required this.diaDoMes,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'data_criacao') required this.dataCriacao,
      @JsonKey(name: 'ultima_geracao') this.ultimaGeracao})
      : super._();

  factory _$FixedTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedTransactionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @override
  final String descricao;
  @override
  final double valor;
  @override
  final TransactionType tipo;
  @override
  @JsonKey(name: 'categoria_id')
  final int categoriaId;

  /// Dia do mês que a transação deve ser lançada (1-31)
  @override
  @JsonKey(name: 'dia_do_mes')
  final int diaDoMes;

  /// Indica se a recorrência está ativa
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Data de criação do template
  @override
  @JsonKey(name: 'data_criacao')
  final DateTime dataCriacao;

  /// Data da última vez que uma transação foi gerada (opcional)
  @override
  @JsonKey(name: 'ultima_geracao')
  final DateTime? ultimaGeracao;

  @override
  String toString() {
    return 'FixedTransaction(id: $id, usuarioId: $usuarioId, descricao: $descricao, valor: $valor, tipo: $tipo, categoriaId: $categoriaId, diaDoMes: $diaDoMes, isActive: $isActive, dataCriacao: $dataCriacao, ultimaGeracao: $ultimaGeracao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.categoriaId, categoriaId) ||
                other.categoriaId == categoriaId) &&
            (identical(other.diaDoMes, diaDoMes) ||
                other.diaDoMes == diaDoMes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao) &&
            (identical(other.ultimaGeracao, ultimaGeracao) ||
                other.ultimaGeracao == ultimaGeracao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, usuarioId, descricao, valor,
      tipo, categoriaId, diaDoMes, isActive, dataCriacao, ultimaGeracao);

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

abstract class _FixedTransaction extends FixedTransaction {
  const factory _FixedTransaction(
          {required final String id,
          @JsonKey(name: 'usuario_id') required final String usuarioId,
          required final String descricao,
          required final double valor,
          required final TransactionType tipo,
          @JsonKey(name: 'categoria_id') required final int categoriaId,
          @JsonKey(name: 'dia_do_mes') required final int diaDoMes,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'data_criacao') required final DateTime dataCriacao,
          @JsonKey(name: 'ultima_geracao') final DateTime? ultimaGeracao}) =
      _$FixedTransactionImpl;
  const _FixedTransaction._() : super._();

  factory _FixedTransaction.fromJson(Map<String, dynamic> json) =
      _$FixedTransactionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'usuario_id')
  String get usuarioId;
  @override
  String get descricao;
  @override
  double get valor;
  @override
  TransactionType get tipo;
  @override
  @JsonKey(name: 'categoria_id')
  int get categoriaId;

  /// Dia do mês que a transação deve ser lançada (1-31)
  @override
  @JsonKey(name: 'dia_do_mes')
  int get diaDoMes;

  /// Indica se a recorrência está ativa
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Data de criação do template
  @override
  @JsonKey(name: 'data_criacao')
  DateTime get dataCriacao;

  /// Data da última vez que uma transação foi gerada (opcional)
  @override
  @JsonKey(name: 'ultima_geracao')
  DateTime? get ultimaGeracao;

  /// Create a copy of FixedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedTransactionImplCopyWith<_$FixedTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
