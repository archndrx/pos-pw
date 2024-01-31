import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/sales/sales_provider.dart';

class SalesChartPage extends StatefulWidget {
  @override
  _SalesChartPageState createState() => _SalesChartPageState();
}

class _SalesChartPageState extends State<SalesChartPage> {
  List<BarChartGroupData> _barGroups = [];
  List<String> _bottomTitles = [];
  bool _isLoading = true;
  final SalesProvider salesProvider = SalesProvider();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await salesProvider.getAllTransactions().first;

    final Map<int, int> monthlyTotalSales = {};

    for (var doc in transactions.docs) {
      final saleData = SaleModel.fromMap(doc.data() as Map<String, dynamic>);
      final monthYearKey =
          saleData.timestamp.toLocal().year * 100 + saleData.timestamp.month;
      final totalSales = saleData.total;

      monthlyTotalSales[monthYearKey] =
          (monthlyTotalSales[monthYearKey] ?? 0) + totalSales;
    }

    final sortedMonthYearKeys = monthlyTotalSales.keys.toList()..sort();

    _barGroups = sortedMonthYearKeys.map((monthYearKey) {
      final month = monthYearKey % 100;
      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            y: monthlyTotalSales[monthYearKey]!.toDouble(),
            colors: [
              Color(0xFFF87C47),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ],
      );
    }).toList();

    _bottomTitles = sortedMonthYearKeys.map((monthYearKey) {
      final month = monthYearKey % 100;
      final year = monthYearKey ~/ 100;
      return DateFormat.MMMM().format(DateTime(year, month));
    }).toList();

    print("_bottomTitles: $_bottomTitles");
    print("_bottomTitles after sorting: $_bottomTitles");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grafik Penjualan',
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) =>
                          TextStyles.poppinsMedium.copyWith(
                        fontSize: 12,
                      ),
                      getTitles: (value) {
                        return DateFormat.MMM().format(
                            DateTime(DateTime.now().year, value.toInt()));
                      },
                      interval: 1,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) =>
                          TextStyles.poppinsMedium.copyWith(
                        fontSize: 12,
                      ),
                      reservedSize: 40,
                      getTitles: (value) {
                        return _formatValue(value);
                      },
                      interval: 50000,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  maxY: _calculateMaxY(),
                  barGroups: _barGroups,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Color(0xFFF87C47),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String month = DateFormat.MMMM().format(
                          DateTime(DateTime.now().year, group.x.toInt()),
                        );
                        String value = _formatValue(rod.y);

                        return BarTooltipItem(
                          '$month\n$value',
                          TextStyles.poppinsMedium.copyWith(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  double _calculateMaxY() {
    final maxCount = _barGroups
        .map((group) => group.barRods.first.y)
        .reduce((a, b) => a > b ? a : b);
    return maxCount + 1;
  }
}

String _formatValue(double value) {
  if (value >= 1000) {
    double formattedValue = value / 1000;
    return '${formattedValue.toStringAsFixed(0)}rb';
  } else {
    return value.toInt().toString();
  }
}
