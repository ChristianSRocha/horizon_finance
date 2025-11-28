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
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    
    state = const AsyncValue.loading();

    try {
      final novaMeta = Meta(
        id: const Uuid().v4(),
        usuarioId: userId,
        nome: nome,
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
}