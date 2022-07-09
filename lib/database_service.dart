import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'models/task.dart';

class DatabaseService {
  final DatabaseReference _databaseReference;
  late Stream<List<Task>> _taskList;

  DatabaseService({required User user}) : _databaseReference = FirebaseDatabase.instance.ref("users/${user.uid}") {
    _taskList = _databaseReference.onValue.asyncMap((event) => event.snapshot.value).cast<List<Task>>();
  }

  Stream<List<Task>> get taskList => _taskList;

  void addTask(Task task) {
    _databaseReference.push().set(task);
  }
}
