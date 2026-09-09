import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import '../widgets/app_shared.dart';
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
      floatingActionButton: const AppAddTaskFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const AppBottomNav(currentTab: AppTab.tasks),
    );
  }
}

/// Greeting bar at the top: today's date, greeting, and a profile icon.

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 1 && hour < 12) {
      return 'Good morning, ';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon, ';
    } else {
      return 'Good evening, ';
    }
  }

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
            ],
          ),
          const SizedBox(height: 5),

          //greeting message
          //NOTE: name is still hardcoded
          RichText(
            text: TextSpan(
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(text: _getGreeting()),
                // TODO: use the real logged-in user's name
                TextSpan(
                  text: 'User.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFC65A42),
                  ),
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
          onTap: () => showAddEditTaskSheet(context, existingTask: task),
          onToggleDone: () async {
            try {
              await FirestoreService().toggleTaskDone(task);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not update task: $e')),
                );
              }
            }
          },
          onDelete: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Delete this task?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirmed != true) return;

            final messenger = ScaffoldMessenger.of(
              context,
            ); // capture BEFORE the await
            await FirestoreService().softDelete(task);
            messenger.showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => FirestoreService().undoDelete(task),
                ),
              ),
            );
          },
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
