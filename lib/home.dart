import 'package:auth_tutorial/database_service.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final DatabaseService databaseService;

  const Home({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Home");
  }
}
