import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/EditReceiptScreen.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/Settings.dart';
import 'package:iphone/photki.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SavedScreen(),
    ExpensesScreen(),
    KnowledgeScreen(),
    SettingsScreen()
  ];

  final List<String> _svgAssets = [
    'assets/1.svg',
    'assets/2.svg',
    'assets/4.svg',
    'assets/5.svg',
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

    setState(() {
      _savedReceipts.insert(0, newReceipt);
      _filteredReceipts.insert(0, newReceipt);
      _sortReceipts();
    });

    await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));
  }

  Future<void> _deleteReceipt(int index) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedReceipts.removeAt(index);
      _filteredReceipts.removeAt(index);
    });

    await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      final newReceipt = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseDetailsScreen(
            image: image,
            onSave: _saveReceipt,
          ),
        ),
      );

      if (newReceipt != null) {
        _saveReceipt(newReceipt);
      }
    }
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выберите источник изображения'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Открыть камеру'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Выбрать из галереи'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
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

  void _onItemTapped(int index) {
    debugPrint('Нажата кнопка: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _pages[_selectedIndex],
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              IgnorePointer(
                child: SvgPicture.asset(
                  _svgAssets[_selectedIndex],
                  width: double.infinity,
                  height: 102,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 105,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///////////////////////////////////////////////////1
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: Icon(
                        size: 55,
                        Icons.home,
                        color: _selectedIndex == 0
                            ? Colors.transparent
                            : Colors.transparent,
                      ),
                    ),
                    ///////////////////////////////////////////////////2
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: Icon(
                        size: 55,
                        Icons.search,
                        color: _selectedIndex == 1
                            ? Colors.transparent
                            : Colors.transparent,
                      ),
                    ),
                    ///////////////////////////////////////////////////3
                    SizedBox(width: 0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: () => _showImageSourceDialog(context),
                        child: Icon(
                          Icons.camera,
                          size: 77,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    ///////////////////////////////////////////////////4
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: Icon(
                        Icons.book,
                        size: 55,
                        color: _selectedIndex == 2
                            ? Colors.transparent
                            : Colors.transparent,
                      ),
                    ),
                    SizedBox(width: 7),
                    ///////////////////////////////////////////////////5
                    GestureDetector(
                      onTap: () => _onItemTapped(3),
                      child: Icon(
                        size: 55,
                        Icons.settings,
                        color: _selectedIndex == 3
                            ? Colors.transparent
                            : Colors.transparent,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
