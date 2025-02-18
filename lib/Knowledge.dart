import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone/NavBar.dart';
import 'package:iphone/Pages.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/knowledge.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          NavBar(),
          Positioned(
            top: 145.h,
            left: 13.w,
            child: GestureDetector(
              onTap: () => _navigateToPage1(context),
              child: Container(
                width: 202.w,
                height: 350.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: 145.h,
            right: 13.w,
            child: GestureDetector(
              onTap: () => _navigateToPage2(context),
              child: Container(
                width: 202.w,
                height: 350.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 130.h,
            left: 13.w,
            child: GestureDetector(
              onTap: () => _navigateToPage3(context),
              child: Container(
                width: 202.w,
                height: 350.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 130.h,
            right: 13.w,
            child: GestureDetector(
              onTap: () => _navigateToPage4(context),
              child: Container(
                width: 202.w,
                height: 350.h,
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
