import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone/NavBar.dart';
import 'package:iphone/Pages.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  _KnowledgeScreenState createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  int _currentIndex = 3;

  void _navigateToPage1(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page1Screen()),
    );
  }

  void _navigateToPage2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page2Screen()),
    );
  }

  void _navigateToPage3(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page3Screen()),
    );
  }

  void _navigateToPage4(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page4Screen()),
    );
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
            'assets/knowledge.png',
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: ScreenUtil().setHeight(145),
            left: ScreenUtil().setWidth(13),
            child: GestureDetector(
              onTap: () => _navigateToPage1(context),
              child: Container(
                width: ScreenUtil().setWidth(202),
                height: ScreenUtil().setHeight(350),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(145),
            right: ScreenUtil().setWidth(13),
            child: GestureDetector(
              onTap: () => _navigateToPage2(context),
              child: Container(
                width: ScreenUtil().setWidth(202),
                height: ScreenUtil().setHeight(350),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: ScreenUtil().setHeight(130),
            left: ScreenUtil().setWidth(13),
            child: GestureDetector(
              onTap: () => _navigateToPage3(context),
              child: Container(
                width: ScreenUtil().setWidth(202),
                height: ScreenUtil().setHeight(350),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: ScreenUtil().setHeight(130),
            right: ScreenUtil().setWidth(13),
            child: GestureDetector(
              onTap: () => _navigateToPage4(context),
              child: Container(
                width: ScreenUtil().setWidth(202),
                height: ScreenUtil().setHeight(350),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
