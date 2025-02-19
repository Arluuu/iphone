import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/Sett.dart';
import 'package:iphone/photki.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final List<String> _images = [
    'assets/5.svg',
    'assets/1.svg',
    'assets/2.svg',
    'assets/4.svg',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseDetailsScreen(
            image: image,
            onSave: (newReceipt) {
              print('New receipt saved: $newReceipt');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              _images[widget.currentIndex],
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            left: 35.w,
            bottom: 37.h,
            child: _buildNavItem(Icons.home, 0, color: Colors.transparent),
          ),
          Positioned(
            left: 100.w,
            bottom: 37.h,
            child: _buildNavItem(Icons.search, 1, color: Colors.transparent),
          ),
          Positioned(
            right: 100.w,
            bottom: 37.h,
            child:
                _buildNavItem(Icons.camera_alt, 2, color: Colors.transparent),
          ),
          Positioned(
            right: 35.w,
            bottom: 37.h,
            child: _buildNavItem(Icons.settings, 3, color: Colors.transparent),
          ),
          Positioned(
            right: 145.w,
            bottom: 35.h,
            child: GestureDetector(
              onTap: () => _openCamera(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 15.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.transparent,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {Color? color}) {
    final isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpensesScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KnowledgeScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color ?? (isSelected ? Colors.transparent : Colors.grey),
            size: 24.sp,
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4.h),
              width: 4.w,
              height: 4.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
