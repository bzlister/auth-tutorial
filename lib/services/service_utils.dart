import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<T> withSpinner<T>(Future<T> Function() fn, BuildContext context) async {
  context.loaderOverlay.show();
  try {
    return await fn();
  } finally {
    context.loaderOverlay.hide();
  }
}
