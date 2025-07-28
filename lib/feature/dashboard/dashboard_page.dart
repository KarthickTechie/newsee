import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:newsee/widgets/side_navigation.dart';

// === Added Constants ===
const double chartTopPadding = 16.0;
const double chartVerticalPadding = 24.0;
const double titleFontSize = 20.0;
const double labelFontSize = 12.0;
const double chartHeight = 300.0;
const double axisNamePadding = 16.0;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  final List<String> _chartTypes = ['Bar', 'Combo', 'Line', 'Donut', 'Pie'];
  String _selectedChartType = 'Bar';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to show chart in full-screen dialog
  void _showFullScreenChart(BuildContext context, Widget chart, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(chartTopPadding),
              child: chart,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidenavigationbar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          DropdownButton<String>(
            value: _selectedChartType,
            items: _chartTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedChartType = newValue!;
                _animationController.reset();
                _animationController.forward();
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(chartTopPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTargetVsAchievedReport(),
              const SizedBox(height: chartVerticalPadding),
              _buildLeadStatusReport(),
              const SizedBox(height: chartVerticalPadding),
              _buildBranchWiseRevenueReport(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetVsAchievedReport() {
    final chart = _buildChart(
      data: [
        ChartData('Chennai', 100, 80),
        ChartData('Mumbai', 120, 90),
        ChartData('Bangalore', 110, 95),
        ChartData('Delhi', 130, 100),
      ],
      series1Name: 'Target',
      series2Name: 'Achieved',
      yAxisLabel: 'Revenue',
    );
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Target vs Achieved',
            style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: chartVerticalPadding),
          GestureDetector(
            onTap: () => _showFullScreenChart(context, chart, 'Target vs Achieved'),
            child: SizedBox(
              height: chartHeight,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadStatusReport() {
    final chart = _buildChart(
      data: [
        ChartData('Chennai', 40, 0),
        ChartData('Mumbai', 35, 0),
        ChartData('Bangalore', 30, 0),
        ChartData('Delhi', 20, 0),
      ],
      series1Name: 'Count',
      singleSeries: true,
      yAxisLabel: 'Revenue crores',
    );
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lead Status',
            style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: chartVerticalPadding),
          GestureDetector(
            onTap: () => _showFullScreenChart(context, chart, 'Lead Status'),
            child: SizedBox(
              height: chartHeight,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchWiseRevenueReport() {
    final chart = _buildChart(
      data: [
        ChartData('Chennai', 200, 0),
        ChartData('Mumbai', 150, 0),
        ChartData('Bangalore', 180, 0),
        ChartData('Delhi', 170, 0),
      ],
      series1Name: 'Revenue',
      singleSeries: true,
      yAxisLabel: 'Revenue crores',
    );
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Branch-wise Revenue',
            style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: chartVerticalPadding),
          GestureDetector(
            onTap: () => _showFullScreenChart(context, chart, 'Branch-wise Revenue'),
            child: SizedBox(
              height: chartHeight,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart({
    required List<ChartData> data,
    required String series1Name,
    String? series2Name,
    bool singleSeries = false,
    required String yAxisLabel,
  }) {
    return _selectedChartType == 'Bar'
        ? BarChart(
            BarChartData(
              barGroups: singleSeries
                  ? data.asMap().entries.map((e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 20),
                        ],
                      )).toList()
                  : data.asMap().entries.map((e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 10),
                          BarChartRodData(toY: e.value.value2, color: Colors.red, width: 10),
                        ],
                      )).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[value.toInt()].category,
                        style: const TextStyle(fontSize: labelFontSize),
                      ),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: labelFontSize),
                    ),
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        yAxisLabel,
                            style: const TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  axisNameSize: axisNamePadding + labelFontSize,
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (event is FlLongPressEnd || event is FlPanEndEvent) {
                    setState(() {
                      _animationController.forward();
                    });
                  }
                },
                handleBuiltInTouches: true,
              ),
              maxY: (data.map((e) => e.value1 + (singleSeries ? 0 : e.value2)).reduce((a, b) => a > b ? a : b) * 1.2),
            ),
            swapAnimationDuration: const Duration(milliseconds: 500),
          )
        : _selectedChartType == 'Combo'
            ? BarChart(
                BarChartData(
                  barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                        x: e.key,
                        barRods: singleSeries
                            ? [
                                BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 20),
                              ]
                            : [
                                BarChartRodData(
                                  toY: e.value.value1 + e.value.value2,
                                  rodStackItems: [
                                    BarChartRodStackItem(0, e.value.value1, Colors.blue),
                                    BarChartRodStackItem(e.value.value1, e.value.value1 + e.value.value2, Colors.red),
                                  ],
                                  width: 20,
                                ),
                              ],
                      )).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data[value.toInt()].category,
                            style: const TextStyle(fontSize: labelFontSize),
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: labelFontSize),
                        ),
                      ),
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            yAxisLabel,
                            style: const TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      axisNameSize: axisNamePadding + labelFontSize,
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      if (event is FlLongPressEnd || event is FlPanEndEvent) {
                        setState(() {
                          _animationController.forward();
                        });
                      }
                    },
                    handleBuiltInTouches: true,
                  ),
                  maxY: (data.map((e) => e.value1 + (singleSeries ? 0 : e.value2)).reduce((a, b) => a > b ? a : b) * 1.2),
                ),
                swapAnimationDuration: const Duration(milliseconds: 500),
              )
            : _selectedChartType == 'Line'
                ? LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value1)).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          dotData: const FlDotData(show: false),
                        ),
                        if (!singleSeries)
                          LineChartBarData(
                            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value2)).toList(),
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 4,
                            dotData: const FlDotData(show: false),
                          ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data[value.toInt()].category,
                                style: const TextStyle(fontSize: labelFontSize),
                              ),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: labelFontSize),
                            ),
                          ),
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                yAxisLabel,
                                style: const TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          axisNameSize: axisNamePadding + labelFontSize,
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, lineTouchResponse) {
                          if (event is FlLongPressEnd || event is FlPanEndEvent) {
                            setState(() {
                              _animationController.forward();
                            });
                          }
                        },
                        handleBuiltInTouches: true,
                      ),
                      maxY: (data.map((e) => e.value1 + (singleSeries ? 0 : e.value2)).reduce((a, b) => a > b ? a : b) * 1.2),
                    ),
                  )
                : _selectedChartType == 'Donut' || _selectedChartType == 'Pie'
                    ? PieChart(
                        PieChartData(
                          sections: data.asMap().entries.map((e) => PieChartSectionData(
                                value: e.value.value1,
                                title: e.value.category,
                                color: Colors.primaries[e.key % Colors.primaries.length],
                                radius: _selectedChartType == 'Donut' ? 100 : 120,
                                titleStyle: const TextStyle(color: Colors.white, fontSize: labelFontSize),
                              )).toList(),
                          centerSpaceRadius: _selectedChartType == 'Donut' ? 50 : 0,
                          sectionsSpace: 2,
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              if (event is FlLongPressEnd || event is FlPanEndEvent) {
                                setState(() {
                                  _animationController.forward();
                                });
                              }
                            },
                          ),
                        ),
                        swapAnimationDuration: const Duration(milliseconds: 500),
                      )
                    : const SizedBox.shrink();
  }
}

class ChartData {
  final String category;
  final double value1;
  final double value2;

  ChartData(this.category, this.value1, this.value2);
}