import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';
import 'package:horizon_finance/features/metas/controllers/metas_controller.dart';
import 'package:horizon_finance/features/metas/models/metas.dart';

// Provider para buscar metas concluídas
final metasConcluidasProvider = FutureProvider<List<Meta>>((ref) async {
  return ref.read(metasRepositoryProvider).getConcludedMetas();
});

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    
    // OBTÉM O ESTADO DAS METAS ATIVAS
    final metasState = ref.watch(metasControllerProvider);
    
    // OBTÉM O ESTADO DAS METAS CONCLUÍDAS
    final metasConcluidasState = ref.watch(metasConcluidasProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Minhas Metas',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryBlue,
          tabs: const [
            Tab(text: 'Ativas'),
            Tab(text: 'Concluídas'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/goals/add'),
        backgroundColor: primaryBlue,
        icon: const Icon(Icons.flag_outlined, color: Colors.white),
        label: const Text(
          "Nova meta",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: 3,
        primaryColor: primaryBlue,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ABA DE METAS ATIVAS
          metasState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
            data: (goals) {
              if (goals.isEmpty) {
                return _buildEmptyState(context, primaryBlue, 'Você ainda não tem metas cadastradas.');
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
                      isConcluded: false,
                    );
                  }).toList(),
                ),
              );
            },
          ),
          
          // ABA DE METAS CONCLUÍDAS
          metasConcluidasState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
            data: (concludedGoals) {
              if (concludedGoals.isEmpty) {
                return _buildEmptyState(context, primaryBlue, 'Você ainda não concluiu nenhuma meta.');
              }
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: concludedGoals.map((meta) {
                    return _buildGoalCard(
                      context: context,
                      ref: ref,
                      meta: meta, 
                      primaryColor: primaryBlue,
                      accentColor: primaryBlue.withOpacity(0.7),
                      isConcluded: true,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required BuildContext context,
    required WidgetRef ref,
    required Meta meta,
    required Color primaryColor,
    required Color accentColor,
    required bool isConcluded,
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
        onTap: isConcluded ? null : () => _showOptionsModal(context, ref, meta, isConcluded),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (isConcluded)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.check_circle, color: const Color(0xFF2E7D32), size: 24),
                          ),
                        Expanded(
                          child: Text(
                            meta.nome,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424242)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isConcluded)
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
                    style: TextStyle(
                      fontSize: 12, 
                      color: isConcluded ? const Color(0xFF2E7D32) : primaryColor,
                      fontWeight: isConcluded ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsModal(BuildContext context, WidgetRef ref, Meta meta, bool isConcluded) {
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
              if (!isConcluded)
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Editar Meta / Adicionar Valor'),
                  onTap: () {
                    Navigator.pop(ctx); 
                    _showEditDialog(context, ref, meta); 
                  },
                ),
              if (!isConcluded)
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

              final justCompleted = !meta.is_concluded && 
                                    novoValor >= meta.valorTotal && 
                                    meta.valorTotal > 0;

              ref.read(metasControllerProvider.notifier).editarMeta(metaAtualizada);
              
              Navigator.pop(ctx);
              
              if (justCompleted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🎉 Parabéns! Você concluiu a meta "$novoNome"!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

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

  Widget _buildEmptyState(BuildContext context, Color primaryColor, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 80, color: primaryColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}