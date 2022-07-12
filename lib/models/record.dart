import 'package:firebase_database/firebase_database.dart';

class Record<T> {
  final T data;
  final String id;

  const Record({required this.data, required this.id});

  factory Record.fromJson(DataSnapshot snapshot, T Function(Map<dynamic, dynamic> data) fromJson) =>
      Record(data: fromJson(snapshot.value as Map<dynamic, dynamic>), id: snapshot.key!);
}
