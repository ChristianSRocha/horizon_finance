import 'package:flutter/material.dart';

/// Widget reutilizável para o menu inferior (BottomAppBar).
/// activeIndex: 0=Dashboard, 1=List, 2=Track, 3=Profile
class BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final VoidCallback? onDashboard;
  final VoidCallback? onList;
  final VoidCallback? onTrack;
  final VoidCallback? onProfile;

  const BottomNavBar({
    super.key,
    required this.activeIndex,
    this.onDashboard,
    this.onList,
    this.onTrack,
    this.onProfile,
  });

  Color _color(BuildContext context, int index) {
    return activeIndex == index ? Theme.of(context).primaryColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.dashboard, color: _color(context, 0)),
            onPressed: onDashboard,
          ),
          IconButton(
            icon: Icon(Icons.list_alt, color: _color(context, 1)),
            onPressed: onList,
          ),
          const SizedBox(width: 40), // Espaço para o FAB (se presente)
          IconButton(
            icon: Icon(Icons.track_changes, color: _color(context, 2)),
            onPressed: onTrack,
          ),
          IconButton(
            icon: Icon(Icons.person, color: _color(context, 3)),
            onPressed: onProfile,
          ),
        ],
      ),
    );
  }
}
