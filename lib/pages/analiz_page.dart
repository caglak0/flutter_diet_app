import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalizScreen extends StatefulWidget {
  const AnalizScreen({Key? key}) : super(key: key);

  @override
  _AnalizScreenState createState() => _AnalizScreenState();
}

class _AnalizScreenState extends State<AnalizScreen> {
  int selectedTimeframe = 1; // 1: Haftalık, 2: Aylık, 3: Yıllık
  List<String> days = [];
  List<double> steps = [];

  @override
  void initState() {
    super.initState();
    updateStepsData(selectedTimeframe);
  }

  void updateStepsData(int timeframe) {
    if (timeframe == 1) {
      steps = [3000, 5000, 4500, 7000, 2000, 5000, 6000];
      days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    } else if (timeframe == 2) {
      steps = [10000, 15000, 12000, 17000, 16000, 18000, 14000];
      days = ["Week1", "Week2", "Week 3", "Week4", "Week5", "Week6", "Week7"];
    } else {
      steps = [120000, 150000, 130000, 110000, 160000, 140000];
      days = ["2019", "2020", "2021", "2022", "2023", "2024"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adım Sayısı Analizi")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int>(
              value: selectedTimeframe,
              items: const [
                DropdownMenuItem(value: 1, child: Text("Haftalık")),
                DropdownMenuItem(value: 2, child: Text("Aylık")),
                DropdownMenuItem(value: 3, child: Text("Yıllık")),
              ],
              onChanged: (int? newValue) {
                if (newValue != null) {
                  selectedTimeframe = newValue;
                  updateStepsData(selectedTimeframe);
                }
              },
            ),
          ),
          Container(
            height: 250, // Burada yüksekliği ayarlayabilirsiniz
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: selectedTimeframe == 3
                    ? 200000
                    : (selectedTimeframe == 2 ? 20000 : 10000),
                minY: 0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(0xff939393),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    margin: 16,
                    getTitles: (double value) =>
                        days[value.toInt() % days.length],
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(0xff939393),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    margin: 10,
                    reservedSize: 30,
                    interval: 2500,
                    getTitles: (double value) {
                      if (value == 0) {
                        return '0';
                      } else if (value % 50000 == 0 && selectedTimeframe == 3) {
                        return '${(value / 1000).toInt()}k';
                      } else if (value % 5000 == 0) {
                        return '${(value / 1000).toInt()}k';
                      }
                      return '';
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(steps.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        y: steps[index],
                        width: 18.0,
                        colors: [Colors.blue],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
