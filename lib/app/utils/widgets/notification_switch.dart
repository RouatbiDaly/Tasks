import 'package:flutter/material.dart';

class NotificationSwitch extends StatelessWidget {
  final bool? notificationValue;
  final Function(bool)? onChanged;
  const NotificationSwitch(
      {super.key, required this.onChanged, required this.notificationValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Notification",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            const Text(
              "Off",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: notificationValue!,
              onChanged: onChanged,
            ),
            Text(
              "On",
              style: TextStyle(
                color: notificationValue!
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
