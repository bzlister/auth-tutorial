import 'package:auth_tutorial/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';

class ToDoListEntry extends StatelessWidget {
  final Task task;
  final String id;
  final TextEditingController _controller;
  final FocusNode _focusNode;

  ToDoListEntry({Key? key, required this.task, required this.id})
      : _controller = TextEditingController(text: task.description),
        _focusNode = FocusNode(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: task.completed,
      onChanged: (checked) {
        _focusNode.unfocus();
        context.read<DatabaseService>().updateTask(id, Task(description: task.description, completed: checked!));
      },
      title: TextField(
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (val) => context.read<DatabaseService>().updateTask(id, Task(description: val, completed: task.completed)),
        style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null),
      ),
      secondary: IconButton(onPressed: () => context.read<DatabaseService>().deleteTask(id), icon: const Icon(Icons.delete)),
    );
  }
}
