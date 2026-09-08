import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'add_edit_task.dart';

// TODO: build a calendar view screen and import it here

// the app's default screen. This IS the task list for now —

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _HomeHeader(),

            // Show the list if we have tasks, otherwise show the empty state
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: FirestoreService().streamTasks(),
                builder: (context, snapshot) {
                  //Firestore initial response
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  //if something is wrong from Firestore
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading tasks: ${snapshot.error}'),
                    );
                  }

                  final tasks = snapshot.data ?? [];
                  return tasks.isEmpty
                      ? const _EmptyState()
                      : _TaskList(tasks: tasks);
                },
              ),
            ),
          ],
        ),
      ),

      // The + button opens the add-task form as a popup (a "bottom sheet")
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () => showAddEditTaskSheet(context),
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _HomeBottomNav(),
    );
  }
}

/// Greeting bar at the top: today's date, greeting, and a profile icon.

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      color: const Color(0xFFFCE8CB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _formattedDate(now).toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, size: 16),
                ],
              ),

              // profile icon on the right, still haven't wired yet
              GestureDetector(
                // TODO: go to a profile/settings screen

                onTap: () => throw UnimplementedError(
                  'Profile screen not implemented yet',
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_outline, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          //greeting message
          //NOTE: name is still hardcoded
          RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: const [
                TextSpan(text: 'Good morning, '),
                // TODO: use the real logged-in user's name
                TextSpan(
                  text: 'User.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Formats a date like "Monday, September 7, 2026"
  String _formattedDate(DateTime d) => DateFormat('EEEE, MMMM d, y').format(d);
}

/// Placeholder for the real task list — not built yet.
/// TODO: show a ListView of task cards here once we have data
class _TaskList extends StatelessWidget {
  final List<Task> tasks;

  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, i) {
        final task = tasks[i];
        return TaskCard(
          task: task,
          // TODO: wire these up once UPDATE/DELETE are built.
          // left as no-ops (instead of throwing) so tapping a card while
          // testing ADD doesn't crash the screen.
          onTap: () {},
          onToggleDone: () {},
          onDelete: () {},
        );
      },
    );
  }
}

/// What the user sees when there are no tasks.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rtl, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No tasks so far',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add your first task',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar with a notch cut out for the FAB to sit in.
class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: const Color(0xFFFCE8CB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // TODO: decide what this button should do (filter? sort?)
          //left icon
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter / sort',
            onPressed: () =>
                throw UnimplementedError('Filter/sort not implemented yet'),
          ),
          const SizedBox(width: 40), // leaves room for the FAB
          // TODO: build a calendar view screen and navigate to it here
          // right icon
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Calendar view',
            onPressed: () =>
                throw UnimplementedError('Calendar view not implemented yet'),
          ),
        ],
      ),
    );
  }
}
