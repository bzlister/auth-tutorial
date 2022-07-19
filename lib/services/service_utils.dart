import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<T> withSpinner<T>(Future<T> Function() fn, {bool useDarkOverlay = false, int timeout = 5000}) async {
  EasyLoading.show(
    dismissOnTap: false,
    maskType: useDarkOverlay ? EasyLoadingMaskType.black : EasyLoadingMaskType.clear,
    indicator: const CircularProgressIndicator(),
  );
  try {
    return await fn().timeout(Duration(milliseconds: timeout), onTimeout: () => throw TimeoutException("Timeout when waiting for network"));
  } finally {
    EasyLoading.dismiss();
  }
}
