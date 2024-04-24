import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StepRadial extends StatelessWidget {
  const StepRadial({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          height: 280,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 210,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      pointers: const [
                        RangePointer(
                          value: 50,
                          width: 18,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Colors.orange,
                          gradient: SweepGradient(
                            colors: [
                              Color.fromARGB(222, 255, 192, 203),
                              Color.fromARGB(222, 228, 99, 142)
                            ],
                            stops: [0.1, 0.75],
                          ),
                        ),
                      ],
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color.fromARGB(77, 187, 166, 166),
                        thickness: 18,
                      ),
                      annotations: const [
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '👣',
                              ),
                              Text(
                                '2500 Adım',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          angle: 270,
                          positionFactor: 0.1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Positioned(
                bottom: 1,
                left: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.whatshot_sharp,
                          color: Colors.red,
                        ),
                        Text(
                          '400',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text('kcal')
                      ],
                    ),
                    SizedBox(width: 60),
                    Column(
                      children: [
                        Icon(
                          Icons.query_builder_rounded,
                          color: Colors.blue,
                        ),
                        Text(
                          '1h 4m',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text('Active time')
                      ],
                    ),
                    SizedBox(width: 60),
                    Column(
                      children: [
                        Icon(Icons.directions_walk),
                        Text(
                          '3',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text('km')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
