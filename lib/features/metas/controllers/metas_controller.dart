import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; 
import 'package:horizon_finance/features/metas/models/metas.dart';
import 'package:horizon_finance/features/metas/repositories/metas_repository.dart';

part 'metas_controller.g.dart';
// Provider do Repositório
@riverpod
MetasRepository metasRepository(MetasRepositoryRef ref) {
  return MetasRepository(Supabase.instance.client);
}

// Controller que gerencia a lista de metas
@riverpod
class MetasController extends _$MetasController {
  
  @override
  FutureOr<List<Meta>> build() {
    return ref.read(metasRepositoryProvider).getMetas();
  }

  Future<void> adicionarMeta({
    required String nome,
    required double valorTotal,
    required DateTime dataFinal,
    String? descricao,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    
    state = const AsyncValue.loading();

    try {
      final novaMeta = Meta(
        id: const Uuid().v4(),
        usuarioId: userId,
        nome: nome,
        descricao: descricao,
        valorTotal: valorTotal,
        valorAtual: 0.0, 
        dataFinal: dataFinal,
        dataCriacao: DateTime.now(),
      );

      await ref.read(metasRepositoryProvider).criarMeta(novaMeta);

   
      ref.invalidateSelf();
      await future; 

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> editarMeta(Meta metaAtualizada) async {
    state = const AsyncValue.loading();
    try {

      final repo = ref.read(metasRepositoryProvider);
      final metas = await repo.getMetas();
      final meta = metas.firstWhere((m) => m.id == metaAtualizada.id);
      final String goalName = meta.nome;
      final bool isConcluded = metaAtualizada.valorAtual >= metaAtualizada.valorTotal;
      final double remanescentValue = metaAtualizada.valorAtual - metaAtualizada.valorTotal;

      if (remanescentValue > 0 && isConcluded)
      {
        await ref.read(TransactionServiceProvider).addTransaction(descricao: "Retorno de valor excedente da meta: '$goalName'",
                                                                  tipo: TransactionType.receita,
                                                                  valor: remanescentValue,
                                                                  data: DateTime.now(),
                                                                  categoriaId: 3,
                                                                  fixedTransaction: false);
      }
      final goalStatus = metaAtualizada.copyWith(is_concluded: isConcluded,
                                                 ativo: isConcluded ? false : metaAtualizada.ativo);
      

      await ref.read(metasRepositoryProvider).atualizarMeta(goalStatus);
      ref.invalidateSelf(); // Recarrega a lista
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> excluirMeta(String id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(metasRepositoryProvider);
      final metas = await repo.getMetas();

      final meta = metas.firstWhere((m) => m.id == id);
      final double remanescentValue = meta.valorAtual;
      final String goalName = meta.nome;

      await repo.deletarMeta(id);

      if (remanescentValue > 0)
      {
        await ref.read(TransactionServiceProvider).addTransaction(descricao: "Retorno de valor devido a exclusão da meta: '$goalName'",
                                                                  tipo: TransactionType.receita,
                                                                  valor: remanescentValue,
                                                                  data: DateTime.now(),
                                                                  categoriaId: 3,
                                                                  fixedTransaction: false,);
      }
      ref.invalidateSelf(); // Recarrega a lista
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}