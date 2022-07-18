import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/authentication_service.dart';
import '../../services/service_utils.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () async {
        await context.read<AuthenticationService>().signInWithGoogle();
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
