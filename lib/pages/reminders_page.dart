import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<List<TimeOfDay>> _reminderTimesList = [
    [
      const TimeOfDay(hour: 8, minute: 0)
    ], // Fiziksel Hareket Hatırlatıcısı varsayılan saat
    [const TimeOfDay(hour: 10, minute: 0)] // Su Hatırlatıcısı varsayılan saat
  ];
  final List<List<bool>> _isReminderOn = [
    [false], // Fiziksel Hareket Hatırlatıcısı durumu
    [false] // Su Hatırlatıcısı durumu
  ];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _addReminder(int index) {
    setState(() {
      _reminderTimesList[index].add(TimeOfDay.now());
      _isReminderOn[index].add(true);
    });
  }

  void _removeReminder(int index, int innerIndex) {
    setState(() {
      _reminderTimesList[index].removeAt(innerIndex);
      _isReminderOn[index].removeAt(innerIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatırlatıcılar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReminderCard(
                  'Fiziksel Hareket Hatırlatıcı', _reminderTimesList[0], 0),
              const SizedBox(height: 20.0),
              _buildReminderCard('Su Hatırlatıcı', _reminderTimesList[1], 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard(String title, List<TimeOfDay> times, int index) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: times.length,
            itemBuilder: (BuildContext context, int innerIndex) {
              return _buildReminderRow(
                times[innerIndex],
                _isReminderOn[index][innerIndex],
                (value) {
                  setState(() {
                    _isReminderOn[index][innerIndex] = value;
                  });
                },
                () => _selectTime(context, times, index, innerIndex),
                () => _removeReminder(
                    index, innerIndex), // silme işlevselliği eklendi
              );
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _addReminder(index),
              child: const Text('+ Hatırlatma Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(
      TimeOfDay time,
      bool isReminderOn,
      void Function(bool) onChanged,
      void Function() onTap,
      VoidCallback onRemove) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Hatırlatma Saati: ${time.format(context)}',
            ),
          ),
          Switch(
            value: isReminderOn,
            onChanged: onChanged,
          ),
          IconButton(
            icon: const Icon(Icons.clear, size: 18), // X ikonunu küçülttük
            onPressed: onRemove, // Silme işlevselliği burada çağrılıyor
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _selectTime(BuildContext context, List<TimeOfDay> times,
      int index, int innerIndex) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: times[innerIndex],
    );
    if (pickedTime != null) {
      setState(() {
        times[innerIndex] = pickedTime;
        _isReminderOn[index][innerIndex] =
            true; // Saat seçildiğinde hatırlatıcıyı etkinleştir
      });
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReminderScreen(),
  ));
}
