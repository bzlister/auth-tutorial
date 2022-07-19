import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'service_utils.dart';

class AuthenticationService {
  final StreamController<User?> _streamController;

  AuthenticationService() : _streamController = StreamController() {
    FirebaseAuth.instance.authStateChanges().handleError((err) => print('auth service error ${err}')).listen((event) {
      _streamController.add(event);
    });
  }

  Stream<User?> get authStateChanges => _streamController.stream;

  void pushToStream(User? user) {
    _streamController.add(user);
  }

  Future<void> signIn({required String email, required String password}) async {
    await withSpinner(() => FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password), useDarkOverlay: true, timeout: 20000);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signUp({required String email, required String password}) async {
    await withSpinner(
      () async {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        userCredential.user!.sendEmailVerification(); // no need to await this
      },
      useDarkOverlay: true,
      timeout: 20000,
    );
  }

  Future<void> signOut() async {
    await withSpinner(FirebaseAuth.instance.signOut, useDarkOverlay: true, timeout: 10000);
  }

  Future<void> deleteAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await withSpinner(FirebaseAuth.instance.currentUser!.delete, useDarkOverlay: true);
    }
  }

  Future<void> sendVerificationEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await withSpinner(FirebaseAuth.instance.currentUser!.sendEmailVerification);
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await withSpinner(() => FirebaseAuth.instance.sendPasswordResetEmail(email: email));
  }

  Future<User?> reload() async {
    await FirebaseAuth.instance.currentUser?.reload();
    return FirebaseAuth.instance.currentUser;
  }
}
