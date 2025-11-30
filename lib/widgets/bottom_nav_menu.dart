import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:horizon_finance/screens/transaction/transaction_form_screen.dart'; 
import 'package:horizon_finance/features/transactions/models/transactions.dart';

class BottomNavMenu extends StatelessWidget {
  final int currentIndex;
  final Color primaryColor;
  final VoidCallback? onTransactionAdded;

  const BottomNavMenu({
    super.key,
    required this.currentIndex,
    required this.primaryColor,
    this.onTransactionAdded,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final inactiveColor = isDarkMode ? Colors.grey[400]! : Colors.grey;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: backgroundColor,
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 1. DASHBOARD
          IconButton(
            icon: Icon(
              Icons.dashboard,
              color: currentIndex == 0 ? primaryColor : inactiveColor,
              size: 24,
            ),
            onPressed: () {
              if (currentIndex != 0) {
                context.go('/dashboard');
              }
            },
          ),

          // 2. RELATÓRIOS
          IconButton(
            icon: Icon(
              Icons.analytics,
              color: currentIndex == 1 ? primaryColor : inactiveColor,
              size: 24,
            ),
            onPressed: () {
              if (currentIndex != 1) {
                context.go('/reports');
              }
            },
          ),

          // 3. BOTÃO DE AÇÃO (ADICIONAR TRANSAÇÃO)
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TransactionFormScreen(
                    initialType: TransactionType.despesa,
                  ),
                ),
              );
              if (result == true) {
                onTransactionAdded?.call();
              }
            },
            backgroundColor: primaryColor,
            elevation: 2,
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),

          // 4. METAS
          IconButton(
            icon: Icon(
              Icons.flag,
              color: currentIndex == 3 ? primaryColor : inactiveColor,
              size: 24,
            ),
            onPressed: () {
              if (currentIndex != 3) {
                context.go('/goals');
              }
            },
          ),

          // 5. PERFIL
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 4 ? primaryColor : inactiveColor,
              size: 24,
            ),
            onPressed: () {
              if (currentIndex != 4) {
                context.go('/profile');
              }
            },
          ),
        ],
      ),
    );
  }
}