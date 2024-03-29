import 'package:flutter/material.dart';

class LinearProgressInCard extends StatelessWidget {
  final double progressValue;

  const LinearProgressInCard({super.key, required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 24,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'Adım',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 20, // Çizginin kalınlığı burada belirlenir
            ),
            const SizedBox(height: 10),
            Text(
              '${(progressValue * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Linear Progress in Card Example'),
      ),
      body: const Center(
        child: LinearProgressInCard(progressValue: 0.7),
      ),
    ),
  ));
}
