import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<List<TimeOfDay>> _reminderTimesList = [[], []];
  List<List<bool>> _isReminderOn = [[], []];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeLocalNotifications();
    _loadData();
  }

  void _initializeLocalNotifications() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedTimes = prefs.getStringList('reminderTimes') ?? [];
    List<bool> storedStatuses =
        prefs.getStringList('isReminderOn')?.map((e) => e == 'true').toList() ??
            [];

    setState(() {
      for (int i = 0; i < storedTimes.length; i++) {
        var parts = storedTimes[i].split(':');
        _reminderTimesList[i ~/ 2].add(
            TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])));
        _isReminderOn[i ~/ 2].add(storedStatuses[i]);
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedTimes = _reminderTimesList
        .expand((list) => list.map((time) => '${time.hour}:${time.minute}'))
        .toList();
    List<String> storedStatuses = _isReminderOn
        .expand((list) => list.map((status) => status.toString()))
        .toList();

    await prefs.setStringList('reminderTimes', storedTimes);
    await prefs.setStringList('isReminderOn', storedStatuses);
  }

  void _addReminder(int index) {
    setState(() {
      _reminderTimesList[index].add(TimeOfDay.now());
      _isReminderOn[index].add(true);
    });
    _saveData();
  }

  void _removeReminder(int index, int innerIndex) {
    setState(() {
      _reminderTimesList[index].removeAt(innerIndex);
      _isReminderOn[index].removeAt(innerIndex);
    });
    _saveData();
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
            child: Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: times.length,
            itemBuilder: (BuildContext context, int innerIndex) {
              return _buildReminderRow(
                  times[innerIndex], _isReminderOn[index][innerIndex], (value) {
                setState(() {
                  _isReminderOn[index][innerIndex] = value;
                });
                _saveData();
              }, () => _selectTime(context, times, index, innerIndex),
                  () => _removeReminder(index, innerIndex));
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
            child: Text('Hatırlatma Saati: ${time.format(context)}'),
          ),
          Switch(value: isReminderOn, onChanged: onChanged),
          IconButton(
              icon: const Icon(Icons.clear, size: 18), onPressed: onRemove),
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
        _isReminderOn[index][innerIndex] = true;
      });
      _saveData();
    }
  }
}

void main() {
  runApp(const MaterialApp(home: ReminderScreen()));
}
