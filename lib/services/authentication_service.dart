import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'service_utils.dart';

class AuthenticationService {
  final StreamController<User?> _streamController;

  AuthenticationService() : _streamController = StreamController() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      _streamController.add(event);
    });
  }

  Stream<User?> get authStateChanges => _streamController.stream;

  void pushToStream(User? user) {
    _streamController.add(user);
  }

  Future<void> signIn({required String email, required String password}) async {
    await call(() => FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password), timeout: 10000);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = await withException(GoogleSignIn().signIn)();
    print('started');
    return await call(() async {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      print("done");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    await call(() async {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.sendEmailVerification(); // no need to await this
    }, timeout: 10000);
  }

  Future<void> signOut() async {
    await call(FirebaseAuth.instance.signOut);
  }

  Future<void> deleteAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await call(FirebaseAuth.instance.currentUser!.delete);
    }
  }

  Future<void> sendVerificationEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await call(FirebaseAuth.instance.currentUser!.sendEmailVerification);
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await call(() => FirebaseAuth.instance.sendPasswordResetEmail(email: email));
  }

  Future<User?> reload() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await withException(FirebaseAuth.instance.currentUser!.reload)();
    }
    return FirebaseAuth.instance.currentUser;
  }
}
