import 'package:flutter/material.dart';
import 'package:flutter_diet_app/service/auth_service.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepRadial extends StatefulWidget {
  const StepRadial({super.key});

  @override
  State<StepRadial> createState() => _StepRadialState();
}

class _StepRadialState extends State<StepRadial> {
  Stream<StepCount>? _stepCountStream;
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthService authServices = AuthService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _todaySteps = '0', _savedSteps = '0';

  int? lastDay;
  User? get currentUser => auth.currentUser;
  late int _currentDay;

  @override
  void initState() {
    super.initState();
    loadData();
    initPlatformState();
  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _currentDay = prefs.getInt('currentDay') ?? DateTime.now().day;
      _todaySteps = prefs.getString('todaySteps') ?? '0';
      lastDay = prefs.getInt('lastDay') ?? _currentDay;
    });

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _savedSteps = data['savedSteps'] ?? _savedSteps;
            _todaySteps = data['todaySteps'] ?? _todaySteps;
          });
        }
      }
    }

    checkDayChange();
  }

  void checkDayChange() async {
    final SharedPreferences prefs = await _prefs;
    int savedDay = prefs.getInt('lastDay') ?? DateTime.now().day;

    if (_currentDay != savedDay) {
      setState(() {
        _savedSteps = _todaySteps;
        _todaySteps = '0';
        lastDay = _currentDay;
      });
      prefs.setInt('lastDay', _currentDay);
      prefs.setString('savedSteps', _savedSteps);
      prefs.setString('todaySteps', _todaySteps);
    }
  }

  @override
  void dispose() {
    saveDataToFirestore();
    _prefs.then((SharedPreferences prefs) {
      prefs.setString('todaySteps', _todaySteps);
      prefs.setInt('currentDay', _currentDay);
      prefs.setString('savedSteps', _savedSteps);
    });
    super.dispose();
  }

  Future<void> saveDataToFirestore() async {
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
        'todaySteps': _todaySteps,
        'savedSteps': _savedSteps,
        'lastDay': lastDay,
      }, SetOptions(merge: true));
    }
  }

  Future<void> onStepCount(StepCount event) async {
    final SharedPreferences prefs = await _prefs;
    _currentDay = DateTime.now().day;
    lastDay = prefs.getInt('lastDay') ?? _currentDay;

    if (_currentDay != lastDay) {
      lastDay = _currentDay;
      _savedSteps = event.steps.toString();
      _todaySteps = '0';
      prefs.setInt('lastDay', lastDay!);
      prefs.setString('savedSteps', _savedSteps);
      prefs.setString('todaySteps', _todaySteps);
    } else {
      setState(() {
        _todaySteps = (event.steps - int.parse(_savedSteps)).toString();
      });
    }

    prefs.setString('savedSteps', _savedSteps);
    prefs.setString('todaySteps', _todaySteps);
  }

  void onStepCountError(error) {
    setState(() {
      _todaySteps = '0';
    });
    saveDataToFirestore();
  }

  void initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;

      _stepCountStream!.listen(onStepCount).onError(onStepCountError);
    }

    if (!mounted) return;
  }

  double calculateKcal(String steps) {
    int stepCount = int.tryParse(steps) ?? 0;
    return stepCount * 0.05;
  }

  String calculateActiveTime(String steps) {
    int stepCount = int.tryParse(steps) ?? 0;
    int km = stepCount ~/ 1312;
    int remainingSteps = stepCount % 1312;
    int minutes = (remainingSteps / 22).round();
    return '$km km $minutes m';
  }

  double calculateKm(String steps) {
    int stepCount = int.tryParse(steps) ?? 0;
    return stepCount / 1312;
  }

  @override
  Widget build(BuildContext context) {
    double kcal = calculateKcal(_todaySteps);
    String activeTime = calculateActiveTime(_todaySteps);
    double km = calculateKm(_todaySteps);
    double stepPercentage = (_todaySteps.isNotEmpty) ? double.parse(_todaySteps) / 400 : 0.0;

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
                      pointers: [
                        RangePointer(
                          value: (stepPercentage > 1.0) ? 1.0 : stepPercentage,
                          width: 18,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Colors.orange,
                          gradient: const SweepGradient(
                            colors: [Color.fromARGB(222, 255, 192, 203), Color.fromARGB(222, 228, 99, 142)],
                            stops: [0.1, 0.75],
                          ),
                        ),
                      ],
                      minimum: 0,
                      maximum: 1.0,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color.fromARGB(77, 187, 166, 166),
                        thickness: 18,
                      ),
                      annotations: [
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/shoe.png', width: 40, height: 40),
                              Text(
                                _todaySteps,
                                style: const TextStyle(
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
              Positioned(
                bottom: 1,
                left: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.whatshot_sharp,
                          color: Colors.red,
                        ),
                        Text(
                          kcal.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text('kcal')
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        const Icon(
                          Icons.query_builder_rounded,
                          color: Colors.blue,
                        ),
                        Text(
                          activeTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text('Active time')
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        const Icon(Icons.directions_walk),
                        Text(
                          km.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text('km')
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
