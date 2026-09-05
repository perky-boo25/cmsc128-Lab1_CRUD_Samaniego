import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class FirestoreService {
  final CollectionReference _taskRef =
    FirebaseFirestore.instance.collection('tasks');

    // CREATE - adding a Task, Firestore auto-generates the doc id
    Future<void> addTask(Task task) async {
      await _taskRef.add(task.toMap());
    }
}
