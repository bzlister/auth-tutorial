import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<T> withSpinner<T>(Future<T> Function() fn, {bool useDarkOverlay = false}) async {
  EasyLoading.show(
    dismissOnTap: false,
    maskType: useDarkOverlay ? EasyLoadingMaskType.black : EasyLoadingMaskType.clear,
    indicator: const CircularProgressIndicator(),
  );
  try {
    return await fn();
  } finally {
    EasyLoading.dismiss();
  }
}
