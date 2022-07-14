import 'dart:math';

import 'package:auth_tutorial/auth/authentication_service.dart';
import 'package:auth_tutorial/database_service.dart';
import 'package:auth_tutorial/to_do_list_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'models/record.dart';
import 'models/task.dart';

class Home extends StatelessWidget {
  final String email;

  const Home({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
          child: Stack(
            alignment: FractionalOffset.center,
            children: [
              const Text(
                "To-Do:",
                style: TextStyle(fontSize: 20),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
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
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Sign out",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 15, bottom: 5, top: 15),
              child: StreamBuilder<List<Record<Task>>>(
                  stream: context.read<DatabaseService>().taskList,
                  builder: (context, state) {
                    List<Record<Task>> tasks = state.data ?? <Record<Task>>[];
                    return SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ...tasks.map((t) => ToDoListEntry(task: t.data, id: t.id)),
                          TextField(
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (val) async {
                              if (val.isNotEmpty) {
                                context.read<DatabaseService>().addTask(Task(description: val));
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
