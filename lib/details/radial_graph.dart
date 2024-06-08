import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGraph extends StatefulWidget {
  final double totalCalories;
  final double maxCalories;

  const RadialGraph({
    super.key,
    required this.totalCalories,
    this.maxCalories = 3000,
  });

  @override
  _RadialGraphState createState() => _RadialGraphState();
}

class _RadialGraphState extends State<RadialGraph> {
  late double _percentage;

  @override
  void initState() {
    super.initState();
    _updatePercentage();
  }

  @override
  void didUpdateWidget(covariant RadialGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalCalories != widget.totalCalories) {
      _updatePercentage();
    }
  }

  void _updatePercentage() {
    setState(() {
      _percentage = (widget.totalCalories / widget.maxCalories) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 3,
      child: SfRadialGauge(
        animationDuration: 1000,
        key: UniqueKey(),
        axes: [
          RadialAxis(
            pointers: [
              RangePointer(
                value: _percentage,
                enableAnimation: true,
                width: 25,
                cornerStyle: CornerStyle.bothCurve,
                color: Colors.orange,
                gradient: const SweepGradient(
                  colors: [Color.fromARGB(222, 255, 192, 203), Color.fromARGB(222, 228, 99, 142)],
                  stops: [0.1, 0.75],
                ),
              )
            ],
            axisLineStyle: const AxisLineStyle(thickness: 25, color: Color.fromARGB(255, 224, 217, 217)),
            startAngle: 130,
            endAngle: 50,
            showLabels: false,
            showTicks: false,
            annotations: [
              GaugeAnnotation(
                widget: Text(
                  '${_percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                angle: 270,
                positionFactor: 0.1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
