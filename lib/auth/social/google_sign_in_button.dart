import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication_service.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                _isSigningIn = true;
              });

              await context.read<AuthenticationService>().signInWithGoogle();

              if (mounted) {
                setState(() {
                  _isSigningIn = false;
                });
              }
            },
            child: SizedBox(
              height: 40,
              child: Stack(
                children: const [
                  Align(alignment: Alignment.centerLeft, child: Image(image: AssetImage("lib/assets/google_logo.png"), height: 20)),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
