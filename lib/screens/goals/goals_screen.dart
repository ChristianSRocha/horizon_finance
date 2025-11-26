import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';
import 'package:horizon_finance/models/financial_goal.dart'; 

class GoalsScreen extends ConsumerWidget { 
  const GoalsScreen({super.key});

  final List<FinancialGoal> goals = const []; 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryBlue = Theme.of(context).primaryColor;
    
    final bool isEmpty = goals.isEmpty;
    final bool isLoading = false;

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
        onPressed: () {
          context.push('/goals/add'); 
        },
        backgroundColor: primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
     
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavMenu(
        currentIndex: 2, 
        primaryColor: primaryBlue,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isEmpty
              ? _buildEmptyState(context, primaryBlue) 
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: goals.map((goal) {
                      return _buildGoalCard(
                        goal: goal,
                        primaryColor: primaryBlue,
                        accentColor: goal.type == GoalType.savings 
                            ? const Color(0xFF2E7D32) 
                            : primaryBlue.withOpacity(0.7),
                      );
                    }).toList(),
                  ),
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

  Widget _buildGoalCard({
    required FinancialGoal goal,
    required Color primaryColor,
    required Color accentColor,
  }) {
    final double safeTargetAmount = goal.targetAmount > 0 ? goal.targetAmount : 1.0; 
    final double progress = goal.currentAmount / safeTargetAmount;
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
              goal.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$ ${goal.currentAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                ),
                Text(
                  'Meta: R\$ ${goal.targetAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
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
}