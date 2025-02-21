import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone/BottomNavigationBar.dart';
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
    ScreenUtil.init(
      context,
      designSize:
          Size(375, 812), // Установите размеры дизайна, которые вы используете
      minTextAdapt: true,
    );

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/settings.png',
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: ScreenUtil().setHeight(125),
            left: ScreenUtil().setWidth(13),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(
                    ScreenUtil().setWidth(346), ScreenUtil().setHeight(60)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                  side: BorderSide.none,
                ),
              ),
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Пользовательское соглашение"
              },
              child: Text(
                '',
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(16)),
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(195),
            left: ScreenUtil().setWidth(13),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(
                    ScreenUtil().setWidth(346), ScreenUtil().setHeight(60)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                ),
              ),
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Политика конфиденциальности"
              },
              child:
                  Text('', style: TextStyle(fontSize: ScreenUtil().setSp(16))),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(280),
            left: ScreenUtil().setWidth(13),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: Size(
                    ScreenUtil().setWidth(346), ScreenUtil().setHeight(60)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                ),
              ),
              onPressed: () {
                _launchURL(
                    'https://www.google.com'); // Замените на "Оценить приложение"
              },
              child:
                  Text('', style: TextStyle(fontSize: ScreenUtil().setSp(16))),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
