import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';
import 'package:horizon_finance/features/metas/controllers/metas_controller.dart';
import 'package:horizon_finance/features/metas/models/metas.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    
    // OBTÉM O ESTADO DO RIVERPOD
    final metasState = ref.watch(metasControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Minhas Metas',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/goals/add'),
        backgroundColor: primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: 2,
        primaryColor: primaryBlue,
      ),

      body: metasState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
        data: (goals) {
          if (goals.isEmpty) {
            return _buildEmptyState(context, primaryBlue);
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: goals.map((meta) {
            
                return _buildGoalCard(
                  context: context,
                  ref: ref,
                  meta: meta, 
                  primaryColor: primaryBlue,
                  accentColor: primaryBlue.withOpacity(0.7),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

 
  Widget _buildGoalCard({
    required BuildContext context,
    required WidgetRef ref,
    required Meta meta,
    required Color primaryColor,
    required Color accentColor,
  }) {
    final double safeTargetAmount = meta.valorTotal > 0 ? meta.valorTotal : 1.0;
    final double progress = meta.valorAtual / safeTargetAmount;
    final String progressPercent = (progress * 100).toStringAsFixed(1);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showOptionsModal(context, ref, meta),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      meta.nome,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242)),
                    ),
                  ),
                  Icon(Icons.more_vert, color: Colors.grey[400]), 
                ],
              ),
              if (meta.descricao != null && meta.descricao!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  meta.descricao!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$ ${meta.valorAtual.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242)),
                  ),
                  Text(
                    'Meta: R\$ ${meta.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF2E7D32),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$progressPercent% concluído',
                    style: TextStyle(fontSize: 12, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  void _showOptionsModal(BuildContext context, WidgetRef ref, Meta meta) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar Meta / Adicionar Valor'),
                onTap: () {
                  Navigator.pop(ctx); 
                  _showEditDialog(context, ref, meta); 
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir Meta', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx); 
                  _confirmDelete(context, ref, meta.id); 
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _showEditDialog(BuildContext context, WidgetRef ref, Meta meta) {
    final nameCtrl = TextEditingController(text: meta.nome);
    final currentValCtrl = TextEditingController(text: meta.valorAtual.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome da Meta'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: currentValCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor Atual Guardado (R\$)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final novoNome = nameCtrl.text;
              final novoValor = double.tryParse(currentValCtrl.text.replaceAll(',', '.')) ?? meta.valorAtual;

              final metaAtualizada = meta.copyWith(
                nome: novoNome,
                valorAtual: novoValor,
              );

              ref.read(metasControllerProvider.notifier).editarMeta(metaAtualizada);
              
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // CONFIRMAÇÃO DE EXCLUSÃO 
  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Meta?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(metasControllerProvider.notifier).excluirMeta(id);
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 80, color: primaryColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            const Text(
              'Você ainda não tem metas cadastradas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Use o botão "+" para adicionar sua primeira meta!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}