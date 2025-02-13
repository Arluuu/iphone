import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iphone/NavBar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          Positioned(
            top: 154,
            left: 13,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(430, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {},
              child: Text('Button 1'),
            ),
          ),
          Positioned(
            top: 243,
            left: 13,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(430, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {},
              child: Text('Button 2'),
            ),
          ),
          Positioned(
            top: 350,
            left: 13,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(430, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {},
              child: Text('Button 3'),
            ),
          ),
        ],
      ),
    );
  }
}
