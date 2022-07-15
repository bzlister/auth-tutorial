import 'package:flutter/material.dart';

import 'auth/account_button.dart';
import 'to_do_list.dart';

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: AccountButton(email: email),
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
            child: const Padding(
              padding: EdgeInsets.only(left: 10, right: 15, bottom: 5, top: 15),
              child: ToDoList(),
            ),
          ),
        ),
      ],
    );
  }
}
