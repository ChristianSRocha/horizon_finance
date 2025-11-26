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
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 1. DASHBOARD
          IconButton(
            icon: Icon(
              Icons.dashboard,
              color: currentIndex == 0 ? primaryColor : Colors.grey,
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
              Icons.list_alt,
              color: currentIndex == 1 ? primaryColor : Colors.grey,
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
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TransactionFormScreen(
                      initialType: TransactionType.despesa),
                ),
              );
              onTransactionAdded?.call();
            },
            // Restaurando o azul original (cor passada via `primaryColor`)
            backgroundColor: primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),

          // 4. METAS
          IconButton(
            icon: Icon(
              Icons.track_changes,
              color: currentIndex == 3 ? primaryColor : Colors.grey,
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
              color: currentIndex == 4 ? primaryColor : Colors.grey,
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
