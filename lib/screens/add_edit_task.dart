import 'package:flutter/material.dart';

import '../models/task.dart';

/// Call this to pop up the add/edit task form as a bottom sheet.
/// Pass [existingTask] to pre-fill the form for editing.
///
/// TODO: once Create/Update exist, save the task inside _save() below
/// and remove this comment.
Future<void> showAddEditTaskSheet(BuildContext context, {Task? existingTask}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true, // lets the sheet grow and avoid the keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AddEditTaskSheet(existingTask: existingTask),
  );
}

/// The add/edit task form itself.
/// It's a StatefulWidget because the form fields change as the user types.
class AddEditTaskSheet extends StatefulWidget {
  final Task? existingTask;

  const AddEditTaskSheet({super.key, this.existingTask});

  @override
  State<AddEditTaskSheet> createState() => _AddEditTaskSheetState();
}

class _AddEditTaskSheetState extends State<AddEditTaskSheet> {
  final _formKey = GlobalKey<FormState>(); // used to validate the form
  late TextEditingController _titleController;
  late DateTime _dueDateTime;
  late Priority _priority;
  late TaskTags _tag;

  // true if we're editing an existing task instead of making a new one
  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    // fill the form with the existing task's data, or sensible defaults
    final task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _dueDateTime = task?.dueDateTime ?? DateTime.now().add(const Duration(hours: 1));
    _priority = task?.priority ?? Priority.medium;
    _tag = task?.tag ?? TaskTags.personal;
  }

  //cleans up the controller so it doesn't leak memory
  @override
  void dispose() {
    _titleController.dispose(); // always dispose controllers
    super.dispose();
  }

  //opens date picker and updates due date, keeping the time as is
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return; // user cancelled
    setState(() {
      _dueDateTime = DateTime(picked.year, picked.month, picked.day, _dueDateTime.hour, _dueDateTime.minute);
    });
  }

  // opens time picker and update due time, keeping the date as is
  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_dueDateTime));
    if (picked == null) return; // user cancelled
    setState(() {
      _dueDateTime = DateTime(_dueDateTime.year, _dueDateTime.month, _dueDateTime.day, picked.hour, picked.minute);
    });
  }

  //validates form and then creates/update task
  void _save() {
    if (!_formKey.currentState!.validate()) return; // stop if title is empty

    // TODO: build a Task from the fields above, then:
    //   - call addTask() if !_isEditing (CREATE — not built yet)
    //   - call updateTask() if _isEditing (UPDATE — not built yet)
    throw UnimplementedError('Save (create/update) not implemented yet');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // pushes the sheet up above the keyboard when it opens
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true, // sheet only takes as much height as it needs
            padding: const EdgeInsets.all(20),
            children: [
              // little grey handle at the top, purely visual
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // title chanfes depending on add or edit mode
              Text(_isEditing ? 'Edit Task' : 'Add Task', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              //tapping opens date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due date'),
                subtitle: Text('${_dueDateTime.year}-${_dueDateTime.month}-${_dueDateTime.day}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),

              // tapping opens the time picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due time'),
                subtitle: Text(TimeOfDay.fromDateTime(_dueDateTime).format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),

              const SizedBox(height: 16),

              // priority dropdown -  get from enum data model
              DropdownButtonFormField<Priority>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),

              // tag dropdown - get from enum data model
              DropdownButtonFormField<TaskTags>(
                initialValue: _tag,
                decoration: const InputDecoration(labelText: 'Tag'),
                items: TaskTags.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (value) => setState(() => _tag = value!),
              ),
              const SizedBox(height: 24),

              //validation + save
              ElevatedButton(onPressed: _save, child: Text(_isEditing ? 'Save Changes' : 'Add Task')),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}