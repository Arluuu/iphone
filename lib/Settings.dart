import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/NavBar.dart';
import 'package:iphone/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/settings.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          NavBar(),
        ],
      ),
    );
  }
}
