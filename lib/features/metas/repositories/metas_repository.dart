import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:horizon_finance/features/metas/models/metas.dart'; 

class MetasRepository {
  final SupabaseClient _client;

  MetasRepository(this._client);

  // Busca todas as metas do usuário logado
  Future<List<Meta>> getMetas() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) throw Exception('Usuário não autenticado');

    final response = await _client
        .from('metas')
        .select()
        .eq('usuario_id', userId)
        .order('data_criacao', ascending: false);


    return (response as List).map((e) => Meta.fromJson(e)).toList();
  }


  Future<void> criarMeta(Meta meta) async {
    await _client.from('metas').insert(meta.toJson());
  }

  Future<void> atualizarMeta(Meta meta) async {
    await _client
        .from('metas')
        .update(meta.toJson())
        .eq('id', meta.id); // 
  }

  Future<void> deletarMeta(String metaId) async {
    await _client.from('metas').delete().eq('id', metaId);
  }
}