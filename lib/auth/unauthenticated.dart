import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication_service.dart';
import '../services/service_utils.dart';
import 'reset_password.dart';
import 'social/google_sign_in_button.dart';

class Unauthenticated extends StatefulWidget {
  final _emailValidationKey = GlobalKey<FormState>();
  final _passwordValidationKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Unauthenticated({Key? key}) : super(key: key);

  @override
  State<Unauthenticated> createState() => _UnauthenticatedState();
}

class _UnauthenticatedState extends State<Unauthenticated> {
  late Mode _mode;
  late bool _shouldValidateEmail;
  late bool _shouldValidatePassword;
  late bool _obscured;

  @override
  void dispose() {
    widget._emailController.dispose();
    widget._passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mode = Mode.signUp;
    _shouldValidateEmail = false;
    _shouldValidatePassword = false;
    _obscured = true;
    super.initState();
  }

  String getErrorMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "Account ${widget._emailController.text} is already in-use.";
      case "invalid-email":
        return "The email you provided is invalid. Please try again with a different email address.";
      case "weak-password":
        return "The password you provided is too weak. Please try again with a new password.";
      case "operation-not-allowed":
        return "Sorry, something went wrong on our end. Please try again later.";
      case "user-disabled":
        return "Account ${widget._emailController.text} has been disabled.";
      case "user-not-found":
        return "Account ${widget._emailController.text} not found.";
      case "wrong-password":
        return "The password you've entered is incorrect.";
      default:
        return commonErrorHandlers(code);
    }
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
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GoogleSignInButton(),
                        ElevatedButton(
                            onPressed: () async {
                              await context.read<AuthenticationService>().signInWithFacebook();
                            },
                            child: const Text("Sign in with Facebook")),
                        const Divider(),
                        const SizedBox(height: 15),
                        Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              setState(() {
                                _shouldValidateEmail = true;
                              });
                            }
                          },
                          child: Form(
                            key: widget._emailValidationKey,
                            child: TextFormField(
                              autovalidateMode: _shouldValidateEmail ? AutovalidateMode.always : AutovalidateMode.disabled,
                              controller: widget._emailController,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              validator: _mode == Mode.signIn
                                  ? (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email address";
                                      }

                                      String trimmed = value.trim();
                                      if (!RegExp(r"^[\p{L}0-9]+@(?:[\p{L}0-9]+\.)+[\p{L}0-9]+$", unicode: true).hasMatch(trimmed)) {
                                        return "Please enter a valid email address";
                                      }

                                      if (trimmed.length > 40) {
                                        return "Email address must less than 40 characters long";
                                      }

                                      return null;
                                    }
                                  : (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email address";
                                      }

                                      return null;
                                    },
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                errorMaxLines: 2,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                hintText: "Email",
                              ),
                            ),
                          ),
                        ),
                        Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              setState(() {
                                _shouldValidatePassword = true;
                              });
                            }
                          },
                          child: Form(
                            key: widget._passwordValidationKey,
                            child: TextFormField(
                              autovalidateMode: _shouldValidatePassword ? AutovalidateMode.always : AutovalidateMode.disabled,
                              controller: widget._passwordController,
                              enableSuggestions: false,
                              autocorrect: false,
                              obscureText: _obscured,
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              validator: _mode == Mode.signIn
                                  ? (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter a password";
                                      }

                                      String trimmed = value.trim();
                                      if (trimmed.length != value.length) {
                                        return "Spaces not allowed in beginning or end of password";
                                      }

                                      if (trimmed.length < 8) {
                                        return "Password must be at least 8 characters long";
                                      }

                                      if (trimmed.length > 30) {
                                        return "Password must less than 30 characters long";
                                      }

                                      if (!RegExp(r"^.*[0-9].*$").hasMatch(trimmed)) {
                                        return "Password must contain at least one number";
                                      }

                                      if (!RegExp(r"^.*[A-Za-z].*$").hasMatch(trimmed)) {
                                        return "Password must contain at least one letter";
                                      }

                                      return null;
                                    }
                                  : (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your password";
                                      }

                                      return null;
                                    },
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscured = !_obscured;
                                      });
                                    },
                                    child: Icon(
                                      _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                errorMaxLines: 2,
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                hintText: "Password",
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                          ),
                          onPressed: () async {
                            if (widget._emailValidationKey.currentState!.validate() && widget._passwordValidationKey.currentState!.validate()) {
                              await (_mode == Mode.signUp
                                      ? context.read<AuthenticationService>().signUp(
                                            email: widget._emailController.text.trim(),
                                            password: widget._passwordController.text.trim(),
                                          )
                                      : context.read<AuthenticationService>().signIn(
                                            email: widget._emailController.text.trim(),
                                            password: widget._passwordController.text.trim(),
                                          ))
                                  .catchError(
                                (error) => context.read<Function(String)>()(
                                  getErrorMessage(error.code),
                                ),
                              );
                            }
                          },
                          child: _mode == Mode.signUp ? const Text("Create account") : const Text("Log in"),
                        ),
                        if (_mode == Mode.signIn) ...[
                          Align(alignment: Alignment.center, child: ResetPassword()),
                        ]
                      ],
                    ),
                  ),
                ),
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
