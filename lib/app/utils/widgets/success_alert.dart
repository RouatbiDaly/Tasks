import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tasks/app/utils/styles/constant_color.dart';

class SuccessAlert extends StatelessWidget {
  const SuccessAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tasks sent successfully!',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset(
            'assets/success.json', // path to your Lottie animation
            width: 200,
            height: 200,
            repeat: false,
          ),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          icon: const Icon(Icons.check, color: kPrimaryColor),
          label: const Text(
            'OK',
            style: TextStyle(color: kPrimaryColor),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kPrimaryColor), // Border color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Border radius
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8), // Padding
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
