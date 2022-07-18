import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';

import '../models/record.dart';
import '../models/task.dart';

class DatabaseService {
  final DatabaseReference _databaseReference;
  late Stream<List<Record<Task>>> taskList;

  DatabaseService({required User user}) : _databaseReference = FirebaseDatabase.instance.ref("users/${user.uid}") {
    taskList = _databaseReference.onValue
        .map((event) => event.snapshot.children.whereNotNull().map((e) => Record<Task>.fromJson(e, Task.fromJson)).toList())
        .handleError((err) => print('database service error ${err}'));
  }

  Future<void> addTask(Task task) async {
    await _databaseReference.push().set(task.toJson());
  }

  Future<void> updateTask(String id, Task task) async {
    await _databaseReference.update({id: task.toJson()});
  }

  Future<void> deleteTask(String id) async {
    await _databaseReference.update({id: null});
  }
}