import 'package:horizon_finance/features/transactions/models/transactions.dart';

class FixedTransactionTemplate {
  final String id;
  final String usuarioId;
  final TransactionType tipo;
  final String descricao;
  final double valor;
  final int diaDoMes;
  final int categoriaId;
  final bool ativo;
  final DateTime dataCriacao;

  FixedTransactionTemplate({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.descricao,
    required this.valor,
    required this.diaDoMes,
    required this.categoriaId,
    required this.ativo,
    required this.dataCriacao,
  });

  factory FixedTransactionTemplate.fromJson(Map<String, dynamic> json) {
    return FixedTransactionTemplate(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: json['tipo'] == 'RECEITA' 
          ? TransactionType.receita 
          : TransactionType.despesa,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      diaDoMes: json['dia_do_mes'] as int,
      categoriaId: json['categoria_id'] as int,
      ativo: json['ativo'] as bool,
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo': tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA',
      'descricao': descricao,
      'valor': valor,
      'dia_do_mes': diaDoMes,
      'categoria_id': categoriaId,
      'ativo': ativo,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }
}
