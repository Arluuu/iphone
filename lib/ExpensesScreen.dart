import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iphone/Knowledge.dart';
import 'package:iphone/SavedScreen.dart';
import 'package:iphone/Settings.dart';
import 'package:iphone/main.dart';
import 'package:iphone/photki.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Map<String, dynamic>> _savedReceipts = [];
  DateTimeRange? _selectedDateRange;
  String _selectedPeriod = "Месяц";
  double circleRadius = 25;
  XFile? _image;

  ////////////////////
  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  void _navigateToKnowledge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KnowledgeScreen()),
    );
  }

  void _openSavedScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SavedScreen()),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseDetailsScreen(
            image: image,
            onSave: (purchaseData) {
              print("Покупка сохранена: \$purchaseData");
            },
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedReceipts();
    _setDefaultDateRange();
  }

  Future<void> _loadSavedReceipts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? receiptsJson = prefs.getString('saved_receipts');

    if (receiptsJson != null) {
      setState(() {
        _savedReceipts =
            List<Map<String, dynamic>>.from(jsonDecode(receiptsJson));
      });
    } else {
      setState(() {
        _savedReceipts = [];
      });
    }
  }

  void _setDefaultDateRange() {
    DateTime today = DateTime.now();
    setState(() {
      _selectedDateRange = DateTimeRange(
        start: today.subtract(Duration(days: 30)),
        end: today,
      );
    });
  }

  void _updateDateRange(String period) {
    DateTime today = DateTime.now();
    DateTime startDate;

    switch (period) {
      case "Неделя":
        startDate = today.subtract(Duration(days: 7));
        break;
      case "Месяц":
        startDate = DateTime(today.year, today.month - 1, today.day);
        break;
      case "Год":
        startDate = DateTime(today.year - 1, today.month, today.day);
        break;
      default:
        startDate = today.subtract(Duration(days: 30));
    }

    setState(() {
      _selectedPeriod = period;
      _selectedDateRange = DateTimeRange(start: startDate, end: today);
    });
  }

  Map<int, double> _getMonthlySums(DateTimeRange dateRange) {
    Map<int, double> monthlySums = {};

    for (var receipt in _savedReceipts) {
      final date = DateTime.parse(receipt['date']);
      final amount = double.tryParse(receipt['amount']) ?? 0.0;
      final month = date.month;

      if (date.isAfter(dateRange.start) && date.isBefore(dateRange.end)) {
        monthlySums[month] = (monthlySums[month] ?? 0.0) + amount;
      }
    }
    return monthlySums;
  }

  List<FlSpot> _getSpots(DateTimeRange dateRange) {
    Map<int, double> monthlySums = _getMonthlySums(dateRange);
    List<FlSpot> spots = [];

    for (int month = 1; month <= 12; month++) {
      double amount = monthlySums[month] ?? 0.0;
      spots.add(FlSpot(month.toDouble(), amount));
    }

    return spots;
  }

  List<String> _getMonths() {
    return [
      'Янв',
      'Фев',
      'Март',
      'Апр',
      'Май',
      'Июнь',
      'Июль',
      'Авг',
      'Сен',
      'Окт',
      'Нояб',
      'Дек'
    ];
  }

  double _getMaxAmount() {
    double maxAmount = 0;
    for (var receipt in _savedReceipts) {
      final amount = double.tryParse(receipt['amount']) ?? 0.0;
      if (amount > maxAmount) {
        maxAmount = amount;
      }
    }
    return maxAmount;
  }

  double _getTotalSpent() {
    double total = 0;
    if (_selectedDateRange == null) return total;

    for (var receipt in _savedReceipts) {
      final date = DateTime.parse(receipt['date']);
      final amount = double.tryParse(receipt['amount']) ?? 0.0;

      if (date.isAfter(_selectedDateRange!.start) &&
          date.isBefore(_selectedDateRange!.end)) {
        total += amount;
      }
    }
    return total;
  }

  int _getTotalPurchases() {
    int count = 0;
    if (_selectedDateRange == null) return count;

    for (var receipt in _savedReceipts) {
      final date = DateTime.parse(receipt['date']);

      if (date.isAfter(_selectedDateRange!.start) &&
          date.isBefore(_selectedDateRange!.end)) {
        count++;
      }
    }
    return count;
  }

  Map<String, double> _getCategorySums() {
    Map<String, double> categorySums = {};

    if (_selectedDateRange == null) return categorySums;

    for (var receipt in _savedReceipts) {
      final date = DateTime.parse(receipt['date']);
      final amount = double.tryParse(receipt['amount']) ?? 0.0;
      final category = receipt['category'] ?? 'Без категории';

      if (date.isAfter(_selectedDateRange!.start) &&
          date.isBefore(_selectedDateRange!.end)) {
        categorySums[category] = (categorySums[category] ?? 0.0) + amount;
      }
    }

    return categorySums;
  }

  Map<String, int> _getCategoryPurchaseCounts() {
    Map<String, int> categoryCounts = {};

    if (_selectedDateRange == null) return categoryCounts;

    for (var receipt in _savedReceipts) {
      final date = DateTime.parse(receipt['date']);
      final category = receipt['category'] ?? 'Без категории';

      if (date.isAfter(_selectedDateRange!.start) &&
          date.isBefore(_selectedDateRange!.end)) {
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }
    }

    return categoryCounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/Expenses.svg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 36.0,
            right: 25.0,
            child: InkWell(
              onTap: () => _openSettings(context),
              child: Container(
                width: 56.0,
                height: 56.0,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 29.0,
            right: 105.0,
            child: InkWell(
              onTap: () => _navigateToKnowledge(context),
              child: Container(
                width: 56.0,
                height: 56.0,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 29.0,
            left: 27.0,
            child: InkWell(
              onTap: () => _openSavedScreen(context),
              child: Container(
                width: 56.0,
                height: 56.0,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 37,
            left: 184,
            child: Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 218, 212, 212),
                borderRadius: BorderRadius.circular(circleRadius = 40),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            child: Container(
              width: 450,
              height: 780,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _savedReceipts.isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedPeriod,
                                  items: ["Неделя", "Месяц", "Год"]
                                      .map((String value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: Colors.orange)),
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _updateDateRange(newValue);
                                    }
                                  },
                                  underline: Container(),
                                  icon: Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.orange),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _selectedDateRange != null
                                      ? 'С ${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start)} по ${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end)}'
                                      : 'Выберите период',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 300,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 1000,
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey.withOpacity(0.3),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 32,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            final index = value.toInt();
                                            if (index < 1 || index > 12)
                                              return Container();
                                            return Text(
                                              _getMonths()[index - 1],
                                              style: TextStyle(fontSize: 12),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: _getMaxAmount() / 4,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toStringAsFixed(0),
                                              style: TextStyle(fontSize: 12),
                                            );
                                          },
                                          reservedSize: 60,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: _getSpots(_selectedDateRange ??
                                            DateTimeRange(
                                                start: DateTime.now().subtract(
                                                    Duration(days: 30)),
                                                end: DateTime.now())),
                                        isCurved: false,
                                        color: Colors.orange,
                                        barWidth: 2,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: true),
                                        belowBarData: BarAreaData(show: false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Количество покупок",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text("${_getTotalPurchases()} шт.",
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Потрачено",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${_getTotalSpent().toStringAsFixed(2)} ₽",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.red)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Column(
                            children: _getCategorySums().entries.map((entry) {
                              final totalSpent = _getTotalSpent();
                              final percentage = totalSpent > 0
                                  ? (entry.value / totalSpent * 100).toInt()
                                  : 0;
                              final purchaseCount =
                                  _getCategoryPurchaseCounts()[entry.key] ?? 0;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(entry.key,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("${purchaseCount} покупок",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              "${entry.value.toStringAsFixed(2)} ₽",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red)),
                                          Text("$percentage%",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: percentage / 100,
                                            strokeWidth: 8,
                                            backgroundColor: Colors.grey[300],
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            "$percentage%",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text('Нет данных для отображения',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 186,
            child: SvgPicture.asset(
              'assets/3.svg',
              width: 83,
              height: 83,
            ),
          ),
          Positioned(
            bottom: 41.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  shape: CircleBorder(),
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                  elevation: 0,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 33,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
