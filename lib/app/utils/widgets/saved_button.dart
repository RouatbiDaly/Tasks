import 'package:flutter/material.dart';

class SavedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SavedButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: const Text("Add Task", style: TextStyle(color: Colors.white)),
    );
  }
}
