// ignore_for_file: unused_import

/*import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> photos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: photos.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return Image.file(File(photos[index]));
                },
              ).px12()
            : "Gallery is empty".text.size(25).make(),
      ).py64(),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
      ),
    );
  }

  Future<void> savePhotoLocally(String fileName, List<int> imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      setState(() {
        photos.add(file.path);
      });
      print('Photo saved locally: ${file.path}');
    } catch (e) {
      print('Error saving photo: $e');
    }
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
      title: "Gallery".text.color(Colors.black).size(24).make(),
      flexibleSpace: Container(
        height: 144,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 136, 0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))),
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

//dummy image code

/*
  Widget buildNavItem(IconData icon, int index) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Implement navigation to the selected page here

        if (widget.onPhotoReceived != null) {
          // Simulate receiving a photo here

          List<int> fakePhotoBytes = List.generate(100, (index) => index % 256);
          widget.onPhotoReceived(fakePhotoBytes);
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
*/
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> photos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(photos: photos, deleteAllPhotos: deleteAllPhotos),
      body: Center(
        child: photos.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      _showDeleteConfirmationDialog(index);
                    },
                    child: Image.file(File(photos[index])),
                    //child: Image.network(photos[index]),
                  );
                },
              ).px12()
            : "Gallery is empty".text.size(25).make(),
      ).py64(),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await captureAndSaveImage();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

// code for firebase

/*
  import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> savePhotoToFirebase(String fileName, List<int> imageBytes) async {
  try {
    final storageRef = firebase_storage.FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(fileName);
    await fileRef.putData(imageBytes);
    final photoUrl = await fileRef.getDownloadURL();
    setState(() {
      photos.add(photoUrl); // Store the download URL in the photos list
    });
    print('Photo uploaded to Firebase Storage: $photoUrl');
  } catch (e) {
    print('Error uploading photo: $e');
  }
}
*/

// this saves file locally

  Future<void> savePhotoLocally(String fileName, List<int> imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      setState(() {
        photos.add(file.path);
      });
      print('Photo saved locally: ${file.path}');
    } catch (e) {
      print('Error saving photo: $e');
    }
  }

  Future<void> captureAndSaveImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageBytes = File(pickedFile.path).readAsBytesSync();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await savePhotoLocally(fileName, imageBytes);
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Photo'),
          content: Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deletePhoto(index); // Delete the photo
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deletePhoto(int index) {
    setState(() {
      File photoFile = File(photos[index]);
      if (photoFile.existsSync()) {
        photoFile.deleteSync();
      }
      photos.removeAt(index);
    });
  }

  void deleteAllPhotos() {
    _showDeleteAllConfirmationDialog();
  }

  void _showDeleteAllConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Photos'),
          content: Text('Are you sure you want to delete all photos?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAllPhotos(); // Delete all photos
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllPhotos() {
    setState(() {
      for (String filePath in photos) {
        File photoFile = File(filePath);
        if (photoFile.existsSync()) {
          photoFile.deleteSync();
        }
      }
      photos.clear();
    });
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> photos;
  final Function() deleteAllPhotos;

  CustomAppBar({
    required this.photos,
    required this.deleteAllPhotos,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      title: "Gallery".text.color(Colors.black).size(24).make(),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'deleteAll') {
              deleteAllPhotos(); // Call the deleteAllPhotos function
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'deleteAll', // Use a unique value
                child: Text('Delete All Photos'),
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
}

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

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
