import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'authentication_service.dart';

class AccountButton extends StatelessWidget {
  final String email;

  const AccountButton({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset.fromDirection(0.75 * pi, 20),
      child: const Icon(Icons.account_circle),
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 0,
          padding: EdgeInsets.zero,
          child: Center(child: Text("Signed in as $email", style: const TextStyle(fontSize: 12))),
        ),
        PopupMenuItem(
          height: 0,
          padding: EdgeInsets.zero,
          child: Center(
            child: TextButton(
              onPressed: () async {
                context.loaderOverlay.show();
                await context.read<AuthenticationService>().signOut();
                context.loaderOverlay.hide();
                navigatorKey.currentState?.pop();
              },
              child: const Text(
                "Sign out",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
