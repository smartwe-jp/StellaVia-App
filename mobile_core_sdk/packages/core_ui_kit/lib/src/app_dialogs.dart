import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialogAction<T> {
  const AppDialogAction({
    required this.label,
    this.value,
    this.isDestructive = false,
    this.isDefaultAction = false,
  });

  final String label;
  final T? value;
  final bool isDestructive;
  final bool isDefaultAction;
}

class AppDialogs {
  const AppDialogs._();

  static bool _isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  static Future<T?> showAdaptiveAlert<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<AppDialogAction<T>> actions,
    bool barrierDismissible = true,
  }) {
    if (_isCupertino(context)) {
      return showCupertinoDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: message == null ? null : Text(message),
            actions: actions.map((action) {
              return CupertinoDialogAction(
                isDestructiveAction: action.isDestructive,
                isDefaultAction: action.isDefaultAction,
                onPressed: () => Navigator.of(dialogContext).pop(action.value),
                child: Text(action.label),
              );
            }).toList(),
          );
        },
      );
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: message == null ? null : Text(message),
          actions: actions.map((action) {
            final style = action.isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  )
                : null;
            return TextButton(
              style: style,
              onPressed: () => Navigator.of(dialogContext).pop(action.value),
              child: Text(action.label),
            );
          }).toList(),
        );
      },
    );
  }
}
