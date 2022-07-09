import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:rubric_grader/auth/authentication_service.dart';
import 'package:async/async.dart';

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
      User? user = await context.read<AuthenticationService>().reload();
      if (user?.emailVerified ?? false) {
        _checkVerifiedLoop.cancel();
        context.read<AuthenticationService>().pushToStream(user);
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We\'ve sent a verification email to ${widget.email}. Please click the link in the email body to get started!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  TextButton(
                    child: const Text("Resend verification link"),
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await context.read<AuthenticationService>().sendVerificationEmail();
                      _checkVerifiedLoop.reset();
                      context.loaderOverlay.hide();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            context.loaderOverlay.show();
            _checkVerifiedLoop.cancel();
            await context.read<AuthenticationService>().signOut();
            context.loaderOverlay.hide();
          },
          child: const Text("Sign out"),
        )
      ],
    );
  }
}
