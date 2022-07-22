import 'package:auth_tutorial/services/service_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/database_service.dart';
import 'models/record.dart';
import 'models/task.dart';
import 'to_do_list_entry.dart';

class ToDoList extends StatelessWidget {
  final TextEditingController _controller;

  ToDoList({Key? key})
      : _controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Record<Task>>>(
              stream: context.read<DatabaseService>().taskList,
              builder: (context, state) {
                if (state.hasError) {
                  context.read<Function(String)>()("We've encountered an error. Please try again later.");
                }
                List<Record<Task>> tasks = state.data ?? <Record<Task>>[];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, i) => ToDoListEntry(key: Key(tasks[i].id), task: tasks[i].data, id: tasks[i].id),
                );
              }),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            controller: _controller,
            onSubmitted: (val) async {
              if (val.isNotEmpty && val.length < 50) {
                await context
                    .read<DatabaseService>()
                    .addTask(Task(
                      description: val.trim(),
                    ))
                    .catchError(
                      (error) => context.read<Function(String)>()(
                        commonErrorHandlers(error.code),
                      ),
                    );
                _controller.clear();
              }
            },
          )
        ],
      ),
    );
  }
}
