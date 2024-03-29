import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Su'),
        ),
        body: const WaterCard(),
      ),
    );
  }
}

class WaterCard extends StatefulWidget {
  const WaterCard({super.key});

  @override
  IconListState createState() => IconListState();
}

class IconListState extends State<WaterCard> {
  List<bool> isBlue = List.generate(8, (index) => false);
  int totalMl = 0;

  void toggleColor(int index) {
    setState(() {
      if (isBlue[index]) {
        totalMl -= (index + 1) * 250;
      } else {
        totalMl += (index + 1) * 250;
      }

      for (int i = 0; i <= index; i++) {
        isBlue[i] = !isBlue[index];
      }

      if (isBlue.every((element) => element) && totalMl >= 2000) {
        showSuccessDialog();
      }
    });
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hedefine ulaştın!'),
          content: const Text('Tebrikler, toplam 2 litre su içtiniz.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 180,
            width: 390,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'SU',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: List.generate(
                        8,
                        (index) => GestureDetector(
                          onTap: () {
                            toggleColor(index);
                          },
                          child: Icon(
                            Icons.local_drink_rounded,
                            size: 36.0,
                            color: isBlue[index] ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          'Toplam Litre: ${(totalMl / 1000).toStringAsFixed(1)}', // "Toplam Litre" ifadesi eklendi
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}