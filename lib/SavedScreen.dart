import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/EditReceiptScreen.dart';
import 'package:iphone/ExpensesScreen.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/Sett.dart';
import 'package:iphone/photki.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          Image.asset(
            _savedReceipts.isNotEmpty
                ? 'assets/saved2.png'
                : 'assets/saved.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 35.h,
            left: 110.w,
            child: GestureDetector(
              onTap: () => _ExpensesScreen(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.transparent, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 35.h,
            right: 105.w,
            child: GestureDetector(
              onTap: () => _navigateToKnowledge(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 35.h,
            right: 25.w,
            child: GestureDetector(
              onTap: () => _openSettings(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120.h,
            left: 67.w,
            right: 20.w,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по названию',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 121.h,
            right: 20.w,
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
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8.r),
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
            top: 170.h,
            left: 20.w,
            right: 20.w,
            bottom: 100.h,
            child: _filteredReceipts.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredReceipts.length,
                    itemBuilder: (context, index) {
                      final receipt = _filteredReceipts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
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
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                    ),
                  ),
          ),
          Positioned(
            bottom: 22.h,
            right: 155.w,
            child: SvgPicture.asset(
              'assets/3.svg',
              width: 70.w,
              height: 70.h,
            ),
          ),
          Positioned(
            bottom: 35.h,
            left: 158.w,
            child: GestureDetector(
              onTap: () => _openCamera(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
