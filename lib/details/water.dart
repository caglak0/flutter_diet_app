import 'package:flutter/material.dart';

class WaterCard extends StatefulWidget {
  const WaterCard({super.key});

  @override
  _WaterCardState createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard> {
  List<bool> isBlue = List.generate(8, (index) => false);
  int totalMl = 0;

  void toggleColor(int index) {
    setState(() {
      for (int i = 0; i < isBlue.length; i++) {
        isBlue[i] = i <= index;
      }

      totalMl = (index + 1) * 250;

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
                          'Toplam Litre: ${(totalMl / 1000).toStringAsFixed(2)}',
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
