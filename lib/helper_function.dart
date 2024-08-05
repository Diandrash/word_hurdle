import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

void showResult({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onPlayAgain,
  required VoidCallback onCancel,
}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: onCancel,
                child: const Text("Quit"),
              ),
              TextButton(
                onPressed: onPlayAgain,
                child: const Text("Play Again"),
              ),
            ],
          ));
}
