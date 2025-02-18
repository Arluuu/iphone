import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone/NavBar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/settings.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          NavBar(),
          Positioned(
            top: 125.h,
            left: 13.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(346.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  side: BorderSide.none,
                ),
              ),
              onPressed: () {},
              child: Text(
                '',
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
          ),
          Positioned(
            top: 195.h,
            left: 13.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(346.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              onPressed: () {},
              child: Text('', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
          Positioned(
            top: 280.h,
            left: 13.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(346.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              onPressed: () {},
              child: Text('', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
