import 'package:auth_tutorial/auth/verify.dart';
import 'package:auth_tutorial/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'authentication_service.dart';

class AuthenticationWrapper extends StatelessWidget {
  final AuthenticationService _authenticationService;

  AuthenticationWrapper({Key? key})
      : _authenticationService = AuthenticationService(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>(
      create: (context) => _authenticationService.authStateChanges,
      initialData: null,
      child: ((User? user) => user != null
          ? user.emailVerified
              ? Home(
                  databaseService: DatabaseService(user: user),
                  authenticationService: _authenticationService,
                )
              : Verify(
                  email: user.email!,
                  authenticationService: _authenticationService,
                )
          : const Unauthenticated())(context.watch<User?>()),
    );
  }
}
