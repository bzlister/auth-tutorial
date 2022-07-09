import 'package:auth_tutorial/auth/unauthenticated.dart';
import 'package:auth_tutorial/auth/verify.dart';
import 'package:auth_tutorial/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'authentication_service.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: ((User? user) => user != null
          ? user.emailVerified
              ? Home(databaseService: DatabaseService(user: user))
              : Verify(email: user.email!)
          : const Unauthenticated())(context.watch<User?>()),
    );
  }
}
