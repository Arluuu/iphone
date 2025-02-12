import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/EditReceiptScreen.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/Knowledge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:iphone/photki.dart';
import 'package:iphone/Settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageSliderScreen(),
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
    'assets/onboarding 41.svg',
    'assets/onboarding 42.svg',
    'assets/onboarding 43.svg',
  ];

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SavedScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SavedScreen()),
      );
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
              return SvgPicture.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            }).toList(),
          ),
          if (_currentPage < _images.length - 1)
            Positioned(
              top: 65.0,
              right: 5.0,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  'Пропустить',
                  style: TextStyle(
                    color: Colors.transparent,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 87.0,
            right: 20.0,
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

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> _savedReceipts = [];
  List<Map<String, dynamic>> _filteredReceipts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _sortNewFirst = true;

  @override
  void initState() {
    super.initState();
    _loadSavedReceipts();
    _searchController.addListener(_filterReceipts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterReceipts);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedReceipts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? receiptsJson = prefs.getString('saved_receipts');

    if (receiptsJson != null) {
      setState(() {
        _savedReceipts =
            List<Map<String, dynamic>>.from(jsonDecode(receiptsJson));
        _filteredReceipts = _savedReceipts;
        _sortReceipts();
      });
    }
  }

  Future<void> _saveReceipt(Map<String, dynamic> newReceipt) async {
    final prefs = await SharedPreferences.getInstance();

    _savedReceipts.insert(0, newReceipt);

    await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));

    setState(() {
      _filterReceipts();
    });
  }

  Future<void> _deleteReceipt(int index) async {
    final prefs = await SharedPreferences.getInstance();

    _savedReceipts.removeAt(index);

    await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));

    setState(() {
      _filterReceipts();
    });
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseDetailsScreen(
            image: image,
            onSave: _saveReceipt,
          ),
        ),
      );
    }
  }

  void _navigateToKnowledge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KnowledgeScreen()),
    );
  }

  void _ExpensesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpensesScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  void _editReceipt(int index) async {
    final receipt = _savedReceipts[index];
    final updatedReceipt = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReceiptScreen(
          receipt: receipt,
          onSave: (updatedData) {
            setState(() {
              _savedReceipts[index] = updatedData;
              _filterReceipts();
            });
          },
        ),
      ),
    );

    if (updatedReceipt != null) {
      setState(() {
        _savedReceipts[index] = updatedReceipt;
        _filterReceipts();
      });
    }
  }

  void _filterReceipts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReceipts = _savedReceipts.where((receipt) {
        final name = receipt['name'].toLowerCase();
        return name.contains(query);
      }).toList();
      _sortReceipts();
    });
  }

  void _sortReceipts() {
    setState(() {
      if (_sortNewFirst) {
        _filteredReceipts.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      } else {
        _filteredReceipts.sort((a, b) =>
            DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
      }
    });
  }

  void _toggleSortOrder(String value) {
    setState(() {
      _sortNewFirst = value == 'Сначала новые';
      _sortReceipts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            _savedReceipts.isNotEmpty
                ? 'assets/saved2.svg'
                : 'assets/saved.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 35,
            left: 110,
            child: GestureDetector(
              onTap: () => _ExpensesScreen(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.transparent, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 195,
            child: GestureDetector(
              onTap: () => _openCamera(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            right: 105,
            child: GestureDetector(
              onTap: () => _navigateToKnowledge(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            right: 25,
            child: GestureDetector(
              onTap: () => _openSettings(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            top: 153,
            left: 67,
            right: 20,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по названию',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 153,
            right: 25,
            child: PopupMenuButton<String>(
              onSelected: _toggleSortOrder,
              itemBuilder: (BuildContext context) {
                return ['Сначала новые', 'Сначала старые'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 215,
            left: 20,
            right: 20,
            bottom: 100,
            child: _filteredReceipts.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredReceipts.length,
                    itemBuilder: (context, index) {
                      final receipt = _filteredReceipts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: receipt['imagePath'].isNotEmpty
                              ? Image.file(File(receipt['imagePath']))
                              : Icon(Icons.image),
                          title: Text(receipt['name']),
                          subtitle: Text(
                              '${receipt['date']} - ${receipt['amount']} руб. - ${receipt['category']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editReceipt(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteReceipt(index);
                                },
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
