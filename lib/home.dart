import 'package:auth_tutorial/auth/authentication_service.dart';
import 'package:auth_tutorial/database_service.dart';
import 'package:auth_tutorial/to_do_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'models/record.dart';
import 'models/task.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ),
          const Text(
            "To-do List:",
            style: TextStyle(fontSize: 24),
          ),
          StreamBuilder<List<Record<Task>>>(
              stream: context.read<DatabaseService>().taskList,
              builder: (context, state) {
                List<Record<Task>> tasks = state.data ?? <Record<Task>>[];
                return SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...tasks.map((t) => ToDoListEntry(task: t.data, id: t.id)),
                      TextField(
                        onSubmitted: (val) async {
                          context.read<DatabaseService>().addTask(Task(description: val));
                        },
                      )
                    ],
                  ),
                );
              }),
          ElevatedButton(
            onPressed: () async {
              context.loaderOverlay.show();
              await context.read<AuthenticationService>().signOut();
              context.loaderOverlay.hide();
            },
            child: const Text("Sign out"),
          )
        ],
      ),
    );
  }
}
