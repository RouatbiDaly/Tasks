import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final void Function()? onTap;
  final bool trailing;
  const CustomListTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: trailing
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: trailing
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context)
                  .colorScheme
                  .error, 
        ),
      ),
      trailing: trailing
          ? Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary)
          : const SizedBox(),
    );
  }
}
