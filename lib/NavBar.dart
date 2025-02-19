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

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
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
    return SizedBox(
      height: 109.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              _images[widget.currentIndex],
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              left: 25.w,
              bottom: 37.h,
              child: Opacity(
                opacity: 0.0,
                child: _buildNavItem(Icons.home, 0, color: Colors.transparent),
              )),
          Positioned(
              left: 95.w,
              bottom: 37.h,
              child: Opacity(
                opacity: 0.0,
                child: _buildNavItem(Icons.home, 1, color: Colors.transparent),
              )),
          Positioned(
            right: 95.w,
            bottom: 37.h,
            child: Opacity(
              opacity: 0.0,
              child: _buildNavItem(Icons.home, 2, color: Colors.transparent),
            ),
          ),
          Positioned(
            right: 22.w,
            bottom: 37.h,
            child: Opacity(
              opacity: 0.0,
              child: _buildNavItem(Icons.home, 3, color: Colors.transparent),
            ),
          ),
          Positioned(
            bottom: 35.h,
            left: 158.w,
            child: GestureDetector(
              onTap: () => _openCamera(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
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

  Widget _buildNavItem(IconData icon, int index, {required Color color}) {
    final isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpensesScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KnowledgeScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.transparent : Colors.grey,
            size: 24.sp,
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4.h),
              width: 4.w,
              height: 4.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
