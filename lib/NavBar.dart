import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/photki.dart';
import 'package:iphone/Sett.dart';
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
              print("Покупка сохранена: $purchaseData");
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
          top: 74.h,
          left: 10.w,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.transparent,
            iconSize: 30.w,
          ),
        ),
        Positioned(
          bottom: 22.h,
          right: 90.w,
          child: InkWell(
            onTap: () => _navigateToKnowledge(context),
            child: Container(
              width: 56.w,
              height: 56.h,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 22.h,
          left: 20.w,
          child: InkWell(
            onTap: () => _goBack(context),
            child: Container(
              width: 56.w,
              height: 56.h,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 22.h,
          right: 20.w,
          child: InkWell(
            onTap: () => _openSettings(context),
            child: Container(
              width: 56.w,
              height: 56.h,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 22.h,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                shape: CircleBorder(),
                backgroundColor: Colors.transparent,
                side: BorderSide.none,
                elevation: 0,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 33.w,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 22.h,
          left: 90.w,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpensesScreen()),
              );
            },
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
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
