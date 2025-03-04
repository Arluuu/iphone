import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  final XFile image;
  final Function(Map<String, dynamic>) onSave;

  const PurchaseDetailsScreen(
      {super.key, required this.image, required this.onSave});

  @override
  _PurchaseDetailsScreenState createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _warrantyDateController = TextEditingController();
  bool _hasWarranty = false;
  late XFile _currentImage;
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
  }

  bool get _isFormValid =>
      _nameController.text.isNotEmpty &&
      _dateController.text.isNotEmpty &&
      _amountController.text.isNotEmpty &&
      _categoryController.text.isNotEmpty &&
      _storeController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty &&
      (_hasWarranty ? _warrantyDateController.text.isNotEmpty : true);

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _currentImage = image;
      });
    }
  }

  void _savePurchaseDetails() {
    final receipt = {
      'id': _uuid.v4(),
      'name': _nameController.text,
      'date': _dateController.text,
      'amount': _amountController.text,
      'category': _categoryController.text,
      'store': _storeController.text,
      'hasWarranty': _hasWarranty,
      'warrantyDate': _hasWarranty ? _warrantyDateController.text : null,
      'description': _descriptionController.text,
      'imagePath': _currentImage.path,
    };

    widget.onSave(receipt);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/pustaya.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().setHeight(150)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(16)),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                  width: double.infinity,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(16)),
                        child: Image.file(
                          File(_currentImage.path),
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(200),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(16)),
                      TextButton(
                        onPressed: _pickImage,
                        child: Text(
                          'Изменить фото',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                _buildInputField(
                    'Название покупки', 'Название', _nameController),
                _buildDatePicker(
                    'Дата покупки', 'Дата покупки', _dateController),
                _buildInputField('Сумма, руб.', 'Потраченная сумма',
                    _amountController, TextInputType.number),
                _buildInputField(
                    'Категория', '#Категория покупки', _categoryController),
                _buildInputField('Магазин', 'Место покупки', _storeController),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Row(
                  children: [
                    Checkbox(
                      value: _hasWarranty,
                      onChanged: (value) {
                        setState(() {
                          _hasWarranty = value!;
                        });
                      },
                    ),
                    Text('Гарантия'),
                  ],
                ),
                if (_hasWarranty)
                  _buildDatePicker('Дата окончания гарантии',
                      'Дата окончания гарантии', _warrantyDateController),
                _buildInputField('Описание', 'Краткое описание покупки',
                    _descriptionController, null),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Center(
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _savePurchaseDetails : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40),
                          vertical: ScreenUtil().setHeight(20)),
                      fixedSize: Size(ScreenUtil().setWidth(343),
                          ScreenUtil().setHeight(65)),
                      backgroundColor:
                          _isFormValid ? Colors.orange : Colors.grey,
                    ),
                    child: Text(
                      'Сохранить',
                      style: TextStyle(fontSize: ScreenUtil().setSp(19)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(-19),
            right: 0,
            child: SvgPicture.asset(
              'assets/statusbarmain.svg',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setHeight(125),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(50),
            left: ScreenUtil().setWidth(7),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.transparent,
              iconSize: ScreenUtil().setWidth(30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller,
      [TextInputType? keyboardType, int maxLines = 1]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: ScreenUtil().setHeight(8)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey, width: ScreenUtil().setWidth(2)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.orange, width: ScreenUtil().setWidth(2)),
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(16)),
      ],
    );
  }

  Widget _buildDatePicker(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: ScreenUtil().setHeight(8)),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey, width: ScreenUtil().setWidth(2)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.orange, width: ScreenUtil().setWidth(2)),
            ),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                controller.text = picked.toLocal().toString().split(' ')[0];
              });
            }
          },
          onChanged: (value) {
            setState(() {});
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(16)),
      ],
    );
  }
}
