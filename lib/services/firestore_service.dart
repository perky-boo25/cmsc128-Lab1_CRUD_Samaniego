import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

//handles all reads/writes to the tasks collection in firestore
class FirestoreService {
  final CollectionReference _taskRef = FirebaseFirestore.instance.collection(
    'tasks',
  );

  // CREATE - adding a Task, Firestore auto-generates the doc id
  Future<void> addTask(Task task) async {
    await _taskRef.add(task.toMap());
  }

  // READ - a live stream of all tasks (recent first)
  // real time Firestoreupdates
  Stream<List<Task>> streamTasks() {
    return _taskRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Task.fromMap(doc.id, doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  //UPDATE (partial): checkbox purposes
  Future<void> toggleTaskDone(Task task) async {
    await _taskRef.doc(task.id).update({'isDone': !task.isDone});
  }
}
