import 'package:flutter/material.dart';
import 'package:tasks/app/utils/styles/light_theme.dart';
import 'package:tasks/app/utils/widgets/navigation_panel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks',
      theme: lightTheme,
      home: const NavigationPanel(),
    );
  }
}
