import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: TabBar(
        labelColor: Theme.of(context).colorScheme.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        indicatorColor: Theme.of(context).colorScheme.secondary,
        tabs: const [
          Tab(text: "Monthly"),
          Tab(text: "Today"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
