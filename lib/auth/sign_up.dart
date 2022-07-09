import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';

import 'authentication_service.dart';

class SignUp extends StatefulWidget {
  final _emailValidationKey = GlobalKey<FormState>();
  final _passwordValidationKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String? _serviceErrorCode;
  late bool _shouldValidateEmail;
  late bool _shouldValidatePassword;
  late bool _obscured;

  @override
  void dispose() {
    widget._emailController.dispose();
    widget._passwordController.dispose();
    super.dispose();
  }

  String getServiceErrorMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "Account ${widget._emailController.text} is already in-use.";
      case "invalid-email":
        return "The email you provided is invalid. Please try again with a different email address.";
      case "weak-password":
        return "The password you provided is too weak. Please try again with a new password.";
      case "operation-not-allowed":
        return "Sorry, something went wrong on our end. Please try again later.";
      default:
        return "Please check your network connection and try again.";
    }
  }

  @override
  void initState() {
    _serviceErrorCode = null;
    _shouldValidateEmail = false;
    _shouldValidatePassword = false;
    _obscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Create an account",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              if (_serviceErrorCode != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: MaterialBanner(content: Text(getServiceErrorMessage(_serviceErrorCode!)), backgroundColor: Colors.red.withOpacity(0.5), actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _serviceErrorCode = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                    )
                  ]),
                )
              ],
              const SizedBox(height: 15),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    setState(() {
                      _shouldValidateEmail = true;
                    });
                  } else if (hasFocus && _serviceErrorCode != null) {
                    setState(() {
                      _serviceErrorCode = null;
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
                    validator: (value) {
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
                  } else if (hasFocus && _serviceErrorCode != null) {
                    setState(() {
                      _serviceErrorCode = null;
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
                    validator: (value) {
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
                            _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
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
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () async {
                  if (widget._emailValidationKey.currentState!.validate() && widget._passwordValidationKey.currentState!.validate()) {
                    try {
                      context.loaderOverlay.show();
                      context.read<AuthenticationService>().signUp(
                            email: widget._emailController.text.trim(),
                            password: widget._passwordController.text.trim(),
                          );
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _serviceErrorCode = e.code;
                      });
                    } finally {
                      context.loaderOverlay.hide();
                    }
                  }
                },
                child: const Text("Create account"),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
