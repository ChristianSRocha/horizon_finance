import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart'; // Para reusar o supabaseClientProvider
import 'package:horizon_finance/features/transactions/models/transactions.dart'; // Para usar o TransactionType

/// 1. Modelo de Categoria
/// (Baseado na sua tabela 'categories' no Supabase)
class Category {
  final int id;
  final String nome;
  final TransactionType tipo;

  Category({required this.id, required this.nome, required this.tipo});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nome: json['nome'],
      // Converte o TEXTO do banco para o ENUM do Dart
      tipo: json['tipo'] == 'RECEITA'
          ? TransactionType.receita
          : TransactionType.despesa,
    );
  }
}

// Provider que busca as categorias
final categoryListProvider =
    FutureProvider.family<List<Category>, TransactionType>((ref, tipo) async {
  
  final supabase = ref.read(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception('Usuário não autenticado');
  }

  // Converte o ENUM de volta para TEXTO para a query
  final tipoString = tipo == TransactionType.receita ? 'RECEITA' : 'DESPESA';

  final response = await supabase
      .from('categories') // 
      .select('id, nome, tipo')
      .eq('tipo', tipoString)
      .order('nome', ascending: true);

  return (response as List).map((json) => Category.fromJson(json)).toList();
});