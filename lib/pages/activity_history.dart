import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ActivityMonitoringPage extends StatefulWidget {
  @override
  _ActivityMonitoringPageState createState() => _ActivityMonitoringPageState();
}

class _ActivityMonitoringPageState extends State<ActivityMonitoringPage> {
  List<String> activityDetails = [];

  void addActivityDetails(String details) {
    setState(() {
      activityDetails.add(details);
    });
  }

  void deleteAllActivity() {
    setState(() {
      activityDetails.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        deleteAllActivity: deleteAllActivity,
      ),
      body: Column(
        children: [
          // Some widgets related to your activity monitoring display
          // ...

          if (activityDetails.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: activityDetails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(activityDetails[index]),
                  );
                },
              ),
            ),
          250.heightBox,
          if (activityDetails.isEmpty)
            "No activity recorded".text.size(25).makeCentered().p(20),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2, // Set the selected index for the Activity page
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() deleteAllActivity;

  CustomAppBar({
    required this.deleteAllActivity,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: "Activity Observed".text.color(Colors.black).size(24).make(),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    _showDeleteAllConfirmationDialog(context);
                  },
                  child: Text('Delete All Activity'),
                ),
              ),
            ];
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        ),
      ],
      flexibleSpace: Container(
        height: 144,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 136, 0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))),
      ),
    );
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Activity'),
          content: Text('Are you sure you want to delete all activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteAllActivity(); // Call the deleteAllActivity function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete All'),
            ),
          ],
        );
      },
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
              backgroundColor: isSelected
                  ? Color.fromARGB(255, 255, 136, 0)
                  : Colors.transparent,
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















// with camera



/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MaterialApp(
    home: CameraPreviewScreen(camera: firstCamera),
  ));
}

class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraPreviewScreen({required this.camera});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityMonitoringPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            // Process the captured image as needed
          } catch (e) {
            print('Error capturing image: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class ActivityMonitoringPage extends StatefulWidget {
  @override
  _ActivityMonitoringPageState createState() => _ActivityMonitoringPageState();
}

class _ActivityMonitoringPageState extends State<ActivityMonitoringPage> {
  List<String> activityDetails = [];

  void addActivityDetails(String details) {
    setState(() {
      activityDetails.add(details);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // Some widgets related to your activity monitoring display
          // ...

          Expanded(
            child: activityDetails.isNotEmpty
                ? ListView.builder(
                    itemCount: activityDetails.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(activityDetails[index]),
                      );
                    },
                  )
                : "No activity recorded".text.size(20).make().p16(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2, // Set the selected index for the Activity page
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: "Activity Observed".text.color(Colors.black).size(24).make(),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    // Delete all activity details
                    _showDeleteAllConfirmationDialog(context);
                  },
                  child: Text('Delete All Activity'),
                ),
              ),
            ];
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        ),
      ],
      flexibleSpace: Container(
        height: 144,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 136, 0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))),
      ),
    );
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Activity'),
          content: Text('Are you sure you want to delete all activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAllActivity(); // Delete all activity details
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllActivity() {
    // Delete all activity details here
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
              backgroundColor: isSelected
                  ? Color.fromARGB(255, 255, 136, 0)
                  : Colors.transparent,
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
}*/