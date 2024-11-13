// Widgets displayed on different pages
import 'package:flutter/material.dart';
import 'package:tasks/app/view/calendar_screen.dart';
import 'package:tasks/app/view/profile_screen.dart';

const List<Widget> pages = <Widget>[
  CalendarScreen(),
  ProfileScreen(),
];

List<BottomNavigationBarItem> buildItems() {
  return <BottomNavigationBarItem>[
    buildItem(Icons.calendar_month_outlined, 'Calendar'),
    buildItem(Icons.person_2_outlined, 'Profile'),
  ];
}

BottomNavigationBarItem buildItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}
