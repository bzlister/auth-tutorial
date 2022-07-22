import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<T> Function() withSpinner<T>(Future<T> Function() fn, int timeout) {
  return () async {
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.clear,
      indicator: const CircularProgressIndicator(),
    );
    try {
      return await fn().timeout(Duration(milliseconds: timeout), onTimeout: () {
        throw TimeoutException("Timeout when waiting for network");
      });
    } finally {
      EasyLoading.dismiss();
    }
  };
}

Future<T> Function() withException<T>(Future<T> Function() fn) {
  return () async {
    try {
      return await fn();
    } on TimeoutException catch (_) {
      throw ServiceException(code: "timeout");
    } on FirebaseAuthException catch (firebaseAuthException) {
      throw ServiceException(code: firebaseAuthException.code);
    } catch (err) {
      throw ServiceException(code: "unknown-error");
    }
  };
}

Future<T> call<T>(Future<T> Function() fn, {int timeout = 5000}) async {
  return await withException(withSpinner(fn, timeout))();
}

String commonErrorHandlers(String? errorCode) {
  switch (errorCode) {
    case "timeout":
      return "Please check your network connection and try again.";
    case "unknown-error":
    default:
      return "Sorry, that didn't work. Please try again later.";
  }
}

class ServiceException implements Exception {
  String code;

  ServiceException({required this.code}) : super();
}
