import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/authentication_service.dart';
import '../services/service_utils.dart';

class ResetPassword extends StatelessWidget {
  final _emailController = TextEditingController();
  final _emailValidationKey = GlobalKey<FormState>();

  ResetPassword({Key? key}) : super(key: key);

  String getErrorMessage(String? code) {
    switch (code) {
      case "invalid-email":
        return "The email you provided is invalid. Please try again with a different email address.";
      case "user-not-found":
        return "Account ${_emailController.text} not found.";
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
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text("Forgot your password?"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              bool shouldValidateEmail = false;
              Status status = Status.sendEmail;

              return AlertDialog(
                title: const Text(
                  "Reset your password",
                  style: TextStyle(fontSize: 24),
                ),
                content: StatefulBuilder(
                  builder: (dialogContext, setState) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (status == Status.sendEmail) ...[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Align(alignment: Alignment.topLeft, child: Text("Enter the email you log in with and we'll send you a link to reset your password")),
                          ),
                          Focus(
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {
                                  shouldValidateEmail = true;
                                });
                              }
                            },
                            child: Form(
                              key: _emailValidationKey,
                              child: TextFormField(
                                autovalidateMode: shouldValidateEmail ? AutovalidateMode.always : AutovalidateMode.disabled,
                                controller: _emailController,
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
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () async {
                                  if (_emailValidationKey.currentState!.validate()) {
                                    await context
                                        .read<AuthenticationService>()
                                        .sendResetPasswordEmail(_emailController.text.trim())
                                        .then((_) => setState(() {
                                              status = Status.emailSent;
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
                        ] else if (status == Status.emailSent) ...[
                          Text("We've sent an email containing a link to reset your password to ${_emailController.text.trim()}"),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

enum Status { sendEmail, emailSent }
