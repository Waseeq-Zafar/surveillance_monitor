// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(), // Hide the default AppBar
      ),
      body: Column(
        children: [
          HomeAppBar(userName: "John Doe", userId: "123456"),
          25.heightBox,
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Recent Activity".text.size(20).semiBold.make().px4(),
                    20.heightBox,
                    Container(
                      width: 350,
                      height: 150,
                      child: Card(
                        color: Colors.grey,
                        elevation: 0.0,
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1618588507085-c79565432917?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmVhdXRpZnVsJTIwbmF0dXJlfGVufDB8fDB8fHww&w=1000&q=80',
                                  ),
                                ),
                              ),
                            ).px12(),
                            SizedBox(width: 10),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Activity Observed".text.bold.size(14).make(),
                                  10.heightBox,
                                ],
                              ).py4(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    40.heightBox,
                    "Cameras".text.semiBold.size(18).make().px4(),
                    20.heightBox,
                    SingleChildScrollView(
                      child: Container(
                        width: 500,
                        height: 200,
                        color: Colors.white,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3, // Number of containers
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 240,
                                height: 100,
                                color: index == 0
                                    ? Colors.blue
                                    : index == 1
                                        ? Colors.green
                                        : Colors.red,
                                child: Center(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                ),
              ],
            ).px(25),
          ),
          BottomNavigation(),
        ],
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final String userName;
  final String userId;

  HomeAppBar({required this.userName, required this.userId});

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting();
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 136, 0),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ).px4(),
              SizedBox(height: 8),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Handle profile icon press
                },
              ),
              SizedBox(height: 10),
              Text(
                'ID: $userId',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ).py(70).px8(),
    );
  }

  String _getGreeting() {
    final now = DateTime.now();
    if (now.hour < 12) {
      return 'Good Morning';
    } else if (now.hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

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
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

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
            if (isSelected)
              const CircleAvatar(
                backgroundColor: Color(0xffFF9800),
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
