import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Image Slider',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(isFirstLaunch: isFirstLaunch),
          routes: {
            '/onboarding': (context) => ImageSliderScreen(),
            '/saved2': (context) => SavedScreen(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const SplashScreen({super.key, required this.isFirstLaunch});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    if (widget.isFirstLaunch) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/saved2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/launch.png',
          width: 375.w,
          height: 812.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ImageSliderScreen extends StatefulWidget {
  const ImageSliderScreen({super.key});

  @override
  ImageSliderScreenState createState() => ImageSliderScreenState();
}

class ImageSliderScreenState extends State<ImageSliderScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> _images = [
    'assets/onboarding_41.png',
    'assets/onboarding_42.png',
    'assets/onboarding_43.png',
  ];

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/saved2');
  }

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/saved2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _images.map((image) {
              return Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            }).toList(),
          ),
          if (_currentPage < _images.length - 1)
            Positioned(
              top: 65.h,
              right: 5.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  'Пропустить',
                  style: TextStyle(
                    color: Colors.transparent,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 87.h,
            right: 20.w,
            child: Opacity(
              opacity: 0.0,
              child: FloatingActionButton(
                heroTag: 'nextPageButton1',
                onPressed: _nextPage,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(Icons.arrow_forward, color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
