import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EditReceiptScreen extends StatefulWidget {
  final Map<String, dynamic> receipt;
  final Function(Map<String, dynamic>) onSave;

  const EditReceiptScreen(
      {super.key, required this.receipt, required this.onSave});

  @override
  _EditReceiptScreenState createState() => _EditReceiptScreenState();
}

class _EditReceiptScreenState extends State<EditReceiptScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _storeController;
  late TextEditingController _descriptionController;
  late TextEditingController _warrantyDateController;
  late bool _hasWarranty;
  late XFile _currentImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.receipt['name']);
    _dateController = TextEditingController(text: widget.receipt['date']);
    _amountController =
        TextEditingController(text: widget.receipt['amount'].toString());
    _categoryController =
        TextEditingController(text: widget.receipt['category']);
    _storeController = TextEditingController(text: widget.receipt['store']);
    _descriptionController =
        TextEditingController(text: widget.receipt['description']);
    _warrantyDateController =
        TextEditingController(text: widget.receipt['warrantyDate'] ?? '');
    _hasWarranty = widget.receipt['hasWarranty'] ?? false;
    _currentImage = XFile(widget.receipt['imagePath']);
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

  void _saveEditedReceipt() {
    final updatedReceipt = {
      'name': _nameController.text,
      'date': _dateController.text,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'category': _categoryController.text,
      'store': _storeController.text,
      'hasWarranty': _hasWarranty,
      'warrantyDate': _hasWarranty ? _warrantyDateController.text : null,
      'description': _descriptionController.text,
      'imagePath': _currentImage.path,
    };

    widget.onSave(updatedReceipt);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize:
          Size(375, 812), // Установите размеры дизайна, которые вы используете
      minTextAdapt: true,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/redaktor.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.fill,
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
                    onPressed: _isFormValid ? _saveEditedReceipt : null,
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
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(-20),
            right: ScreenUtil().setWidth(0),
            child: SvgPicture.asset(
              'assets/statbar.svg',
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setHeight(130),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(57),
            left: ScreenUtil().setWidth(4),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
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
