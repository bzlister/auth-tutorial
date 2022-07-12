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
    return Provider<AuthenticationService>(
      create: (_) => AuthenticationService(),
      builder: (context, child) => StreamBuilder<User?>(
        stream: context.read<AuthenticationService>().authStateChanges,
        builder: (context, state) {
          User? user = state.data;
          return user != null
              ? user.emailVerified
                  ? Provider<DatabaseService>(
                      create: (_) => DatabaseService(user: user),
                      child: const Home(),
                    )
                  : Verify(email: user.email!)
              : const Unauthenticated();
        },
      ),
    );
  }
}
