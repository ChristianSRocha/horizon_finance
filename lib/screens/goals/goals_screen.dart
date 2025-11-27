import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';
import 'package:horizon_finance/features/metas/controllers/metas_controller.dart';

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
      
      // BUILDER DO ASYNC VALUE
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
                // Mapeando seu Model 'Meta' para o layout
                return _buildGoalCard(
                  goalName: meta.nome,
                  currentAmount: meta.valorAtual,
                  targetAmount: meta.valorTotal,
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

  // Ajustei levemente para receber os dados primitivos ou o objeto Meta novo
  Widget _buildGoalCard({
    required String goalName,
    required double currentAmount,
    required double targetAmount,
    required Color primaryColor,
    required Color accentColor,
  }) {
    final double safeTargetAmount = targetAmount > 0 ? targetAmount : 1.0;
    final double progress = currentAmount / safeTargetAmount;
    final String progressPercent = (progress * 100).toStringAsFixed(1);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goalName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$ ${currentAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                ),
                Text(
                  'Meta: R\$ ${targetAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0), // Proteção visual
                backgroundColor: Colors.grey.shade300,
                color: accentColor,
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
    );
  }
  
  // _buildEmptyState permanece igual...
  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
     // ... seu código original do empty state ...
     return Center(child: Text("Lista Vazia")); // Simplificado para brevidade
  }
}