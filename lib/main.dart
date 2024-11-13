import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks/app/app.dart';
import 'package:tasks/app/utils/helper/database_helper.dart';
import 'package:tasks/app/utils/styles/constant_color.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  tz.initializeTimeZones();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kTransportColor,
      systemNavigationBarColor: kBackgroundColor,
    ),
  );
  runApp(const MyApp());
}
