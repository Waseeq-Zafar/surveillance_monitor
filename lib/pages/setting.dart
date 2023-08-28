// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surveillance_monitor/pages/activity_history.dart';
import 'package:surveillance_monitor/pages/gallery.dart';
import 'package:surveillance_monitor/pages/homepage.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Settings'.text.color(Colors.black).size(24).make(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 3,
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  final int selectedIndex; // Add a selectedIndex property

  BottomNavigation({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffD9D9D9),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(Icons.home, 0),
          20.widthBox,
          buildNavItem(CupertinoIcons.photo_camera_solid, 1),
          20.widthBox,
          buildNavItem(Icons.history_outlined, 2),
          20.widthBox,
          buildNavItem(Icons.settings, 3),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    bool isSelected = index == widget.selectedIndex;

    return GestureDetector(
      onTap: () {
        // Navigate to different pages based on the selected index
        if (index == 0) {
          Navigator.pushNamed(context, '/');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/gallery');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/activity');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/settings');
        }
      },
      child: Container(
        width: 65,
        height: 65,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? Color(0xffFF9800) : Colors.transparent,
              radius: 30,
            ),
            Icon(
              icon,
              size: 35,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
