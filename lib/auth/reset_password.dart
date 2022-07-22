import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/authentication_service.dart';
import '../services/service_utils.dart';

class ResetPassword extends StatefulWidget {
  final _emailController = TextEditingController();
  final _emailValidationKey = GlobalKey<FormState>();

  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late bool _shouldValidateEmail;
  late Status _status;

  String getErrorMessage(String? code) {
    switch (code) {
      case "invalid-email":
        return "The email you provided is invalid. Please try again with a different email address.";
      case "user-not-found":
        return "Account ${widget._emailController.text} not found.";
      case "missing-android-pkg-name":
      case "missing-continue-uri":
      case "unauthorized-continue-uri":
      case "invalid-continue-uri":
      case "missing-ios-bundle-id":
        return "Sorry, something went wrong on our end. Please try again later.";
      default:
        return commonErrorHandlers(code);
    }
  }

  @override
  void initState() {
    _shouldValidateEmail = false;
    _status = Status.sendEmail;
    super.initState();
  }

  @override
  void dispose() {
    widget._emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Reset your password",
        style: TextStyle(fontSize: 24),
      ),
      content: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            if (_status == Status.sendEmail) ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Align(alignment: Alignment.topLeft, child: Text("Enter the email you log in with and we'll send you a link to reset your password")),
              ),
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
                    validator: (value) {
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
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget._emailValidationKey.currentState!.validate()) {
                        await context
                            .read<AuthenticationService>()
                            .sendResetPasswordEmail(widget._emailController.text.trim())
                            .then((_) => setState(() {
                                  _status = Status.emailSent;
                                }))
                            .catchError(
                              (error) => context.read<Function(String)>()(getErrorMessage(error.code)),
                            );
                      }
                    },
                    child: const Text("Send"),
                  ),
                ),
              ),
            ] else if (_status == Status.emailSent) ...[
              Text("We've sent an email containing a link to reset your password to ${widget._emailController.text.trim()}"),
              ElevatedButton(
                onPressed: () {
                  navigatorKey.currentState?.pop();
                },
                child: const Text("Log in"),
              ),
            ],
          ])),
    );
  }
}

enum Status { sendEmail, emailSent }
