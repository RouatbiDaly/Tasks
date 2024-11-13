import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final int maxLines;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? displayText;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.title,
    required this.hint,
    this.maxLines = 1,
    this.icon,
    this.onTap,
    this.displayText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller:
                    controller ?? TextEditingController(text: displayText),
                maxLines: maxLines,
                enabled: onTap ==
                    null, 
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  icon: icon != null ? Icon(icon, color: Colors.grey) : null,
                ),
                readOnly:
                    onTap != null, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
