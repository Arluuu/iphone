import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone/NavBar.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentIndex = 0;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/settings.png',
            width: 375.w,
            height: 812.h,
            fit: BoxFit.cover,
          ),
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
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Пользовательское соглашение"
              },
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
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Политика конфиденциальности"
              },
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
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Оценить приложение"
              },
              child: Text('', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
          // CustomNavBar поверх основного контента
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
