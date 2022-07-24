import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/authentication_service.dart';
import '../services/service_utils.dart';

class AccountButton extends StatelessWidget {
  final String email;

  const AccountButton({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset.fromDirection(0.75 * pi, 20),
      child: const Icon(Icons.account_circle, size: 40),
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 0,
          padding: EdgeInsets.zero,
          child: Center(child: Text("Signed in as $email", style: const TextStyle(fontSize: 14))),
        ),
        PopupMenuItem(
          height: 0,
          padding: EdgeInsets.zero,
          child: Center(
            child: TextButton(
              onPressed: () async {
                await context.read<AuthenticationService>().signOut().catchError(
                      (error) => context.read<Function(String)>()(
                        commonErrorHandlers(error.code),
                      ),
                    );
                navigatorKey.currentState?.pop();
              },
              child: const Text(
                "Sign out",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
