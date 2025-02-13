import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/main.dart';
import 'package:iphone/photki.dart';
import 'package:iphone/Settings.dart';
import 'package:iphone/Knowledge.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  void _goBack(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SavedScreen()),
    );
  }

  void _navigateToKnowledge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KnowledgeScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseDetailsScreen(
            image: image,
            onSave: (purchaseData) {
              print("Покупка сохранена: \$purchaseData");
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 74.0,
          left: 10.0,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.transparent,
            iconSize: 30.0,
          ),
        ),
        Positioned(
          bottom: 29.0,
          right: 105.0,
          child: InkWell(
            onTap: () => _navigateToKnowledge(context),
            child: Container(
              width: 56.0,
              height: 56.0,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          left: 25.0,
          child: InkWell(
            onTap: () => _goBack(context),
            child: Container(
              width: 56.0,
              height: 56.0,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 36.0,
          right: 25.0,
          child: InkWell(
            onTap: () => _openSettings(context),
            child: Container(
              width: 56.0,
              height: 56.0,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 41.0,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                shape: CircleBorder(),
                backgroundColor: Colors.transparent,
                side: BorderSide.none,
                elevation: 0,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 33,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35.0,
          left: 110.0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpensesScreen()),
              );
            },
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.attach_money,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
