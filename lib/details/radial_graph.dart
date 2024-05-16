import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGraph extends StatelessWidget {
  const RadialGraph({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 3,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            pointers: const [
              RangePointer(
                value: 50,
                width: 25,
                cornerStyle: CornerStyle.bothCurve,
                color: Colors.orange,
                gradient: SweepGradient(colors: [
                  Color.fromARGB(222, 255, 192, 203),
                  Color.fromARGB(222, 228, 99, 142)
                ], stops: [
                  0.1,
                  0.75
                ]),
              )
            ],
            axisLineStyle: const AxisLineStyle(
                thickness: 25, color: Color.fromARGB(255, 224, 217, 217)),
            startAngle: 5,
            endAngle: 5,
            showLabels: false,
            showTicks: false,
            annotations: const [
              GaugeAnnotation(
                widget: Text(
                  '50%',
                  style: TextStyle(
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
