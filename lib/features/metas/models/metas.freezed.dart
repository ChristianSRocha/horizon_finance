// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metas.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return _Meta.fromJson(json);
}

/// @nodoc
mixin _$Meta {
  String get id => throw _privateConstructorUsedError;
  String get usuarioId => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String? get descricao => throw _privateConstructorUsedError;
  double get valorTotal => throw _privateConstructorUsedError;
  double get valorAtual => throw _privateConstructorUsedError;
  DateTime? get dataFinal => throw _privateConstructorUsedError;
  bool get is_concluded => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;
  DateTime get dataCriacao => throw _privateConstructorUsedError;

  /// Serializes this Meta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaCopyWith<Meta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaCopyWith<$Res> {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) then) =
      _$MetaCopyWithImpl<$Res, Meta>;
  @useResult
  $Res call(
      {String id,
      String usuarioId,
      String nome,
      String? descricao,
      double valorTotal,
      double valorAtual,
      DateTime? dataFinal,
      bool is_concluded,
      bool ativo,
      DateTime dataCriacao});
}

/// @nodoc
class _$MetaCopyWithImpl<$Res, $Val extends Meta>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? nome = null,
    Object? descricao = freezed,
    Object? valorTotal = null,
    Object? valorAtual = null,
    Object? dataFinal = freezed,
    Object? is_concluded = null,
    Object? ativo = null,
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
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      descricao: freezed == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String?,
      valorTotal: null == valorTotal
          ? _value.valorTotal
          : valorTotal // ignore: cast_nullable_to_non_nullable
              as double,
      valorAtual: null == valorAtual
          ? _value.valorAtual
          : valorAtual // ignore: cast_nullable_to_non_nullable
              as double,
      dataFinal: freezed == dataFinal
          ? _value.dataFinal
          : dataFinal // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      is_concluded: null == is_concluded
          ? _value.is_concluded
          : is_concluded // ignore: cast_nullable_to_non_nullable
              as bool,
      ativo: null == ativo
          ? _value.ativo
          : ativo // ignore: cast_nullable_to_non_nullable
              as bool,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaImplCopyWith<$Res> implements $MetaCopyWith<$Res> {
  factory _$$MetaImplCopyWith(
          _$MetaImpl value, $Res Function(_$MetaImpl) then) =
      __$$MetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String usuarioId,
      String nome,
      String? descricao,
      double valorTotal,
      double valorAtual,
      DateTime? dataFinal,
      bool is_concluded,
      bool ativo,
      DateTime dataCriacao});
}

/// @nodoc
class __$$MetaImplCopyWithImpl<$Res>
    extends _$MetaCopyWithImpl<$Res, _$MetaImpl>
    implements _$$MetaImplCopyWith<$Res> {
  __$$MetaImplCopyWithImpl(_$MetaImpl _value, $Res Function(_$MetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? nome = null,
    Object? descricao = freezed,
    Object? valorTotal = null,
    Object? valorAtual = null,
    Object? dataFinal = freezed,
    Object? is_concluded = null,
    Object? ativo = null,
    Object? dataCriacao = null,
  }) {
    return _then(_$MetaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      descricao: freezed == descricao
          ? _value.descricao
          : descricao // ignore: cast_nullable_to_non_nullable
              as String?,
      valorTotal: null == valorTotal
          ? _value.valorTotal
          : valorTotal // ignore: cast_nullable_to_non_nullable
              as double,
      valorAtual: null == valorAtual
          ? _value.valorAtual
          : valorAtual // ignore: cast_nullable_to_non_nullable
              as double,
      dataFinal: freezed == dataFinal
          ? _value.dataFinal
          : dataFinal // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      is_concluded: null == is_concluded
          ? _value.is_concluded
          : is_concluded // ignore: cast_nullable_to_non_nullable
              as bool,
      ativo: null == ativo
          ? _value.ativo
          : ativo // ignore: cast_nullable_to_non_nullable
              as bool,
      dataCriacao: null == dataCriacao
          ? _value.dataCriacao
          : dataCriacao // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MetaImpl implements _Meta {
  const _$MetaImpl(
      {required this.id,
      required this.usuarioId,
      required this.nome,
      this.descricao,
      required this.valorTotal,
      required this.valorAtual,
      this.dataFinal,
      this.is_concluded = false,
      this.ativo = true,
      required this.dataCriacao});

  factory _$MetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaImplFromJson(json);

  @override
  final String id;
  @override
  final String usuarioId;
  @override
  final String nome;
  @override
  final String? descricao;
  @override
  final double valorTotal;
  @override
  final double valorAtual;
  @override
  final DateTime? dataFinal;
  @override
  @JsonKey()
  final bool is_concluded;
  @override
  @JsonKey()
  final bool ativo;
  @override
  final DateTime dataCriacao;

  @override
  String toString() {
    return 'Meta(id: $id, usuarioId: $usuarioId, nome: $nome, descricao: $descricao, valorTotal: $valorTotal, valorAtual: $valorAtual, dataFinal: $dataFinal, is_concluded: $is_concluded, ativo: $ativo, dataCriacao: $dataCriacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.valorTotal, valorTotal) ||
                other.valorTotal == valorTotal) &&
            (identical(other.valorAtual, valorAtual) ||
                other.valorAtual == valorAtual) &&
            (identical(other.dataFinal, dataFinal) ||
                other.dataFinal == dataFinal) &&
            (identical(other.is_concluded, is_concluded) ||
                other.is_concluded == is_concluded) &&
            (identical(other.ativo, ativo) || other.ativo == ativo) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, usuarioId, nome, descricao,
      valorTotal, valorAtual, dataFinal, is_concluded, ativo, dataCriacao);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      __$$MetaImplCopyWithImpl<_$MetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaImplToJson(
      this,
    );
  }
}

abstract class _Meta implements Meta {
  const factory _Meta(
      {required final String id,
      required final String usuarioId,
      required final String nome,
      final String? descricao,
      required final double valorTotal,
      required final double valorAtual,
      final DateTime? dataFinal,
      final bool is_concluded,
      final bool ativo,
      required final DateTime dataCriacao}) = _$MetaImpl;

  factory _Meta.fromJson(Map<String, dynamic> json) = _$MetaImpl.fromJson;

  @override
  String get id;
  @override
  String get usuarioId;
  @override
  String get nome;
  @override
  String? get descricao;
  @override
  double get valorTotal;
  @override
  double get valorAtual;
  @override
  DateTime? get dataFinal;
  @override
  bool get is_concluded;
  @override
  bool get ativo;
  @override
  DateTime get dataCriacao;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
