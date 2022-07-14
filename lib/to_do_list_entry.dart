import 'package:auth_tutorial/database_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    return ListTile(
      leading: Checkbox(
        activeColor: Colors.blue,
        value: task.completed,
        onChanged: (checked) {
          _focusNode.unfocus();
          context.read<DatabaseService>().updateTask(id, Task(description: task.description, completed: checked!));
        },
      ),
      contentPadding: EdgeInsets.zero,
      title: GestureDetector(
        onLongPress: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete task?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.loaderOverlay.show();
                  context.read<DatabaseService>().deleteTask(id).then((value) => context.loaderOverlay.hide());
                },
                child: const Text("Delete"),
              ),
            ],
          ),
        ),
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          color: Colors.transparent,
          child: IgnorePointer(
            child: TextField(
              cursorColor: Colors.white,
              focusNode: _focusNode,
              controller: _controller,
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  context.read<DatabaseService>().updateTask(id, Task(description: val, completed: task.completed));
                }
              },
              style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}