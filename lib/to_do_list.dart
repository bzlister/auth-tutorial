import 'package:auth_tutorial/services/service_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/database_service.dart';
import 'models/record.dart';
import 'models/task.dart';
import 'to_do_list_entry.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Record<Task>>>(
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
                      await withSpinner(() => context.read<DatabaseService>().addTask(Task(description: val)), context);
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
