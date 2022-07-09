import 'package:auth_tutorial/auth/authentication_service.dart';
import 'package:auth_tutorial/database_service.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final DatabaseService databaseService;
  final AuthenticationService authenticationService;

  const Home({Key? key, required this.databaseService, required this.authenticationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Home");
  }
}
