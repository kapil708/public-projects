import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SnackBarType { success, error, info, warning }

showSnackBarFun(context) {
  SnackBar snackBar = SnackBar(
    content: const Text(
      'Yay! A SnackBar at the top!',
      style: TextStyle(fontSize: 20),
    ),
    backgroundColor: Colors.indigo,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 10, right: 10),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
  TextStyle? style,
  Duration? duration,
  Color? backgroundColor,
}) {
  var snackBar = SnackBar(
    content: Text(
      message,
      style: style ??
          Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
    ),
    duration: duration ?? const Duration(seconds: 1),
    backgroundColor: backgroundColor ?? (type == SnackBarType.success ? Colors.green : Colors.black),
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - (150 + kToolbarHeight + kBottomNavigationBarHeight), left: 10, right: 10),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

showAlertDialog({
  required BuildContext context,
  String? title,
  TextStyle? titleStyle,
  Widget? titleWidget,
  bool hideTitle = false,
  required String body,
  Widget? bodyWidget,
  TextStyle? bodyStyle,
  List<Widget>? actions,
  String? defaultActionText,
  VoidCallback? defaultActionOnPressed,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog.adaptive(
        title: !hideTitle
            ? titleWidget ??
                Text(
                  title ?? 'Alert!',
                  style: titleStyle,
                )
            : null,
        content: bodyWidget ??
            Text(
              body,
              style: bodyStyle ?? Theme.of(context).textTheme.bodyLarge,
            ),
        actions: actions ??
            [
              TextButton(
                onPressed: defaultActionOnPressed ?? () => context.pop(),
                child: Text(
                  defaultActionText ?? "Okay",
                ),
              ),
            ],
      );
    },
  );
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (e) {
    return false;
  }
}
