import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/EditReceiptScreen.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/Sett.dart';
import 'package:iphone/photki.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    SavedScreen(),
    ExpensesScreen(),
    KnowledgeScreen(),
    SettingsScreen(),
  ];

  final List<String> _images = [
    'assets/5.svg',
    'assets/1.svg',
    'assets/2.svg',
    'assets/4.svg',
  ];

  final ImagePicker _picker = ImagePicker();
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

  Future<void> _openCamera(BuildContext context) async {
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(_images[0]),
            label: 'Сохраненные',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(_images[1]),
            label: 'Расходы',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _openCamera(context),
              child: SvgPicture.asset(_images[2]),
            ),
            label: 'Камера',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(_images[3]),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
