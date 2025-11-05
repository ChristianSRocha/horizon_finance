import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart';
import 'package:horizon_finance/screens/reports/reports_screen.dart';
import 'package:horizon_finance/screens/goals/goals_screen.dart';
import 'package:horizon_finance/screens/profile/profile_screen.dart';

class BottomNavMenu extends StatelessWidget {
  final int currentIndex;
  final Color primaryColor;

  const BottomNavMenu({
    super.key,
    required this.currentIndex,
    required this.primaryColor,
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ReportsScreen()),
                );
              }
            },
          ),

          const SizedBox(width: 40), // Espaço para o FAB

          // 3. METAS
          IconButton(
            icon: Icon(
              Icons.track_changes,
              color: currentIndex == 2 ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 2) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GoalsScreen()),
                );
              }
            },
          ),

          // 4. PERFIL
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 3 ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 3) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}