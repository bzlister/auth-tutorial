import 'package:auth_tutorial/auth/sign_in.dart';
import 'package:auth_tutorial/auth/sign_up.dart';
import 'package:flutter/material.dart';

class Unauthenticated extends StatefulWidget {
  const Unauthenticated({Key? key}) : super(key: key);

  @override
  State<Unauthenticated> createState() => _UnauthenticatedState();
}

class _UnauthenticatedState extends State<Unauthenticated> {
  late Mode _mode;

  @override
  void initState() {
    _mode = Mode.signUp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(_mode == Mode.signUp ? "Create an account" : "Log in", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              Padding(
                padding: const EdgeInsets.all(8),
                child: _mode == Mode.signUp ? SignUp() : SignIn(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _mode == Mode.signUp
                    ? [
                        const Text("Have an account?"),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = Mode.signIn;
                            });
                          },
                          child: const Text("Log in"),
                        ),
                      ]
                    : [
                        const Text("No account?"),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _mode = Mode.signUp;
                              });
                            },
                            child: const Text("Sign up"))
                      ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum Mode { signIn, signUp }
