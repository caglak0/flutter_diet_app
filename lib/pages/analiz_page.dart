import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalizScreen extends StatefulWidget {
  const AnalizScreen({super.key});

  @override
  _AnalizScreenState createState() => _AnalizScreenState();
}

class _AnalizScreenState extends State<AnalizScreen> {
  int selectedTimeframe = 1;
  List<String> days = [];
  List<double> steps = [];

  final List<double> dailyCalories = [2000, 2500, 1800, 3600, 4500, 2800, 1500];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                '👣 Adım Sayısı Analizi',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButton<int>(
                value: selectedTimeframe,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Haftalık")),
                  DropdownMenuItem(value: 2, child: Text("Aylık")),
                  DropdownMenuItem(value: 3, child: Text("Yıllık")),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedTimeframe = newValue;
                      updateStepsData(selectedTimeframe);
                    });
                  }
                },
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  BarChart(
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
                              fontSize: 13),
                          margin: 10,
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
                          reservedSize: 40,
                          interval: 2500,
                          getTitles: (double value) {
                            if (value == 0) {
                              return '0';
                            } else if (value % 50000 == 0 &&
                                selectedTimeframe == 3) {
                              return '${value ~/ 1000}k';
                            } else if (value % 5000 == 0) {
                              return '${value ~/ 1000}k';
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
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10),
              child: Text(
                '🔥 Kalori Analizi',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            // x eksenindeki etiketleri oluştur
                            switch (value.toInt()) {
                              case 0:
                                return 'Mon';
                              case 1:
                                return 'Tue';
                              case 2:
                                return 'Wed';
                              case 3:
                                return 'Thu';
                              case 4:
                                return 'Fri';
                              case 5:
                                return 'Sat';
                              case 6:
                                return 'Sun';
                            }
                            return '';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            // y eksenindeki etiketleri oluştur
                            if (value % 500 == 0) {
                              return value.toInt().toString();
                            }
                            return '';
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: dailyCalories.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value);
                          }).toList(),
                          isCurved: true,
                          colors: [Colors.blue],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      minY: 1000,
                      maxY: 5000,
                      minX: 0,
                      maxX: 6,
                      gridData: FlGridData(
                        horizontalInterval: 500, // Y eksenindeki aralık
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 1,
                      color: Colors.red,
                      width: double.infinity,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: Text(
                        'Ort',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Ekranın daha fazla aşağı inmesi için boşluk ekledim
          ],
        ),
      ),
    );
  }
}
