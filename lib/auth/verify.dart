import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';

import '../services/authentication_service.dart';
import '../services/service_utils.dart';

class Verify extends StatefulWidget {
  final String email;

  const Verify({Key? key, required this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  late RestartableTimer _checkVerifiedLoop;

  @override
  void initState() {
    _checkVerifiedLoop = RestartableTimer(const Duration(seconds: 1), () async {
      AuthenticationService authenticationService = context.read<AuthenticationService>();
      User? user = await authenticationService.reload();
      if (user?.emailVerified ?? false) {
        _checkVerifiedLoop.cancel();
        authenticationService.pushToStream(user);
      } else {
        _checkVerifiedLoop.reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _checkVerifiedLoop.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Verify your email',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "We've sent a verification email to ${widget.email}. Please click the link in the email body to get started!",
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  TextButton(
                    child: const Text("Resend verification link"),
                    onPressed: () async {
                      await context.read<AuthenticationService>().sendVerificationEmail().catchError(
                            (error) => context.read<Function(String)>()(
                              commonErrorHandlers(error.code),
                            ),
                          );
                      _checkVerifiedLoop.reset();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            _checkVerifiedLoop.cancel();
            await context.read<AuthenticationService>().signOut().catchError(
                  (error) => context.read<Function(String)>()(
                    commonErrorHandlers(error.code),
                  ),
                );
          },
          child: const Text("Sign out"),
        )
      ],
    );
  }
}
