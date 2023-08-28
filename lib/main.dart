import 'package:flutter/material.dart';
import 'package:surveillance_monitor/pages/activity_history.dart';
import 'package:surveillance_monitor/pages/gallery.dart';
import 'package:surveillance_monitor/pages/homepage.dart';
import 'package:surveillance_monitor/pages/setting.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/gallery': (context) => GalleryPage(),
      '/activity': (context) => ActivityMonitoringPage(),
      '/settings': (context) => SettingsPage(),
    },
  ));
}
