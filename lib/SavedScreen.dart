import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iphone/EditReceiptScreen.dart';
import 'package:iphone/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'photki.dart';

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

    bool isDuplicate = _savedReceipts.any((receipt) =>
        receipt['date'] == newReceipt['date'] &&
        receipt['amount'] == newReceipt['amount']);

    if (!isDuplicate) {
      setState(() {
        _savedReceipts.insert(0, newReceipt);
        _filteredReceipts.insert(0, newReceipt);
        _sortReceipts();
      });

      await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));
    }
  }

  Future<void> _deleteReceipt(int index) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedReceipts.removeAt(index);
      _filterReceipts();
    });

    await prefs.setString('saved_receipts', jsonEncode(_savedReceipts));
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

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
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                _savedReceipts.isNotEmpty
                    ? 'assets/saved2.png'
                    : 'assets/saved.png',
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(127),
              left: ScreenUtil().setWidth(50),
              right: ScreenUtil().setWidth(80),
              child: Container(
                height: ScreenUtil().setHeight(45),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      hintText: 'Поиск по названию',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(10)),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(10)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(10)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(123),
              right: ScreenUtil().setWidth(20),
              child: Container(
                width: ScreenUtil().setWidth(45),
                height: ScreenUtil().setHeight(45),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(8)),
                ),
                child: PopupMenuButton<String>(
                  onSelected: _toggleSortOrder,
                  itemBuilder: (BuildContext context) {
                    return ['Сначала новые', 'Сначала старые']
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  child: Center(
                    child: Icon(Icons.sort, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(170),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setHeight(100),
              child: _filteredReceipts.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredReceipts.length,
                      itemBuilder: (context, index) {
                        final receipt = _filteredReceipts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(10)),
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
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
