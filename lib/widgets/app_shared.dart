import 'package:flutter/material.dart';

import '../screens/add_edit_task.dart';
import '../screens/calendar_screen.dart';

enum AppTab { tasks, calendar, profile }

class AppAddTaskFAB extends StatelessWidget {
  const AppAddTaskFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => showAddEditTaskSheet(context),
      backgroundColor: const Color(0xFFC65A42),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text(
        'Add Task',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  final AppTab currentTab;

  const AppBottomNav({super.key, required this.currentTab});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Color(0xFFFCE8CB),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.list_alt,
              label: 'Tasks',
              selected: currentTab == AppTab.tasks,
              onTap: () {
                if (currentTab == AppTab.tasks) return;
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            _NavItem(
              icon: Icons.calendar_month_outlined,
              label: 'Calendar',
              selected: currentTab == AppTab.calendar,
              onTap: () {
                if (currentTab == AppTab.calendar) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: currentTab == AppTab.profile,
              onTap: () => throw UnimplementedError(
                'Profile screen not implemented yet',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFFF1DDBE) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF4A3427)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF4A3427), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
