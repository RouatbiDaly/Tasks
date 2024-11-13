import 'package:flutter/material.dart';

class ConfirmationAlert extends StatelessWidget {
  const ConfirmationAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Sync'),
      content: const Text('Are you sure you want to send tasks to the API?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
