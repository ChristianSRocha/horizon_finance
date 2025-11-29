import 'package:freezed_annotation/freezed_annotation.dart';

// CORREÇÃO AQUI: O nome antes do .freezed e .g deve ser igual ao nome do arquivo (metas.dart)
part 'metas.freezed.dart';
part 'metas.g.dart';


@freezed
class Meta with _$Meta {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Meta({
    required String id,
    required String usuarioId,
    required String nome, 
    String? descricao,
    required double valorTotal,
    required double valorAtual,
    DateTime? dataFinal,
    @Default(false) bool is_concluded, 
    @Default(true) bool ativo, 

    required DateTime dataCriacao,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}