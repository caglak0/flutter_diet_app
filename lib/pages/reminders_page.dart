import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_diet_app/service/notification_logic.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<List<TimeOfDay>> _reminderTimesList = [[], []];
  final List<List<bool>> _isReminderOn = [[], []];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeLocalNotifications();
    _loadData();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        NotificationLogic.init(context, widget.userId);
        _fetchNotificationsOnAppStart(
            0); // Fiziksel Hareket Hatırlatıcılar için
        _fetchNotificationsOnAppStart(1); // Su Hatırlatıcılar için
      }
    });
  }

  // Firestore'dan bildirimleri getirmek için uygulama başlatıldığında
  void _fetchNotificationsOnAppStart(int categoryIndex) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fetchNotificationsFromDatabase(widget.userId, categoryIndex);
    }
  }

  // Firestore'dan bildirimleri getir
  void _fetchNotificationsFromDatabase(String userId, int categoryIndex) {
    FirebaseFirestore.instance
        .collection('reminders')
        .doc(userId)
        .collection('user_reminders_$categoryIndex')
        .snapshots()
        .listen((snapshot) {
      // Verileri işleyin ve bildirimleri başlatın
      for (var doc in snapshot.docs) {
        var reminderData = doc.data();
        var reminderTitle = reminderData['title'] as String;
        var reminderBody = reminderData['body'] as String;
        var scheduledDateTime =
            (reminderData['scheduledDateTime'] as Timestamp).toDate();

        // Bildirimi başlatmak için NotificationLogic sınıfındaki ilgili metotları çağırın
        NotificationLogic.scheduleNotification(
          id: int.parse(doc.id),
          title: reminderTitle,
          body: reminderBody,
          payload: 'reminder_payload_${categoryIndex}_${doc.id}',
          scheduledDateTime: scheduledDateTime,
          categoryIndex: categoryIndex,
        );
      }
    });
  }

  void _initializeLocalNotifications() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('mipmap/ic_launcher'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedTimes0 = prefs.getStringList('reminderTimes0');
    List<String>? storedTimes1 = prefs.getStringList('reminderTimes1');
    List<String>? storedStatuses0 = prefs.getStringList('isReminderOn0');
    List<String>? storedStatuses1 = prefs.getStringList('isReminderOn1');

    if (storedTimes0 != null && storedStatuses0 != null) {
      setState(() {
        _reminderTimesList[0] = storedTimes0.map((time) {
          var parts = time.split(':');
          return TimeOfDay(
              hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }).toList();
        _isReminderOn[0] = storedStatuses0.map((e) => e == 'true').toList();
      });
    }

    if (storedTimes1 != null && storedStatuses1 != null) {
      setState(() {
        _reminderTimesList[1] = storedTimes1.map((time) {
          var parts = time.split(':');
          return TimeOfDay(
              hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }).toList();
        _isReminderOn[1] = storedStatuses1.map((e) => e == 'true').toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'reminderTimes0',
        _reminderTimesList[0]
            .map((time) => '${time.hour}:${time.minute}')
            .toList());
    await prefs.setStringList(
        'reminderTimes1',
        _reminderTimesList[1]
            .map((time) => '${time.hour}:${time.minute}')
            .toList());
    await prefs.setStringList('isReminderOn0',
        _isReminderOn[0].map((status) => status.toString()).toList());
    await prefs.setStringList('isReminderOn1',
        _isReminderOn[1].map((status) => status.toString()).toList());
  }

  void _addReminder(int index) {
    setState(() {
      // Burada doğru listeye hatırlatıcı ekleniyor
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

  void addReminderToFirestore(String title, String body,
      DateTime scheduledDateTime, int categoryIndex) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('reminders')
          .doc(widget.userId)
          .collection('user_reminders_$categoryIndex')
          .add({
        'title': title,
        'body': body,
        'scheduledDateTime': scheduledDateTime,
      });
    }
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
              }, () => _selectTime(context, index, innerIndex, index),
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
      VoidCallback onTap,
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

  Future<void> _selectTime(BuildContext context, int index, int innerIndex,
      int categoryIndex) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTimesList[index][innerIndex],
    );
    if (pickedTime != null) {
      setState(() {
        _reminderTimesList[index][innerIndex] = pickedTime;
        _isReminderOn[index][innerIndex] = true;
      });
      _saveData();
      // Hatırlatma zamanı seçildiğinde bildirimi zamanına göre planla
      // Kullanıcının seçtiği zamanı alarak, günün tarihini ayarla
      DateTime scheduledDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (scheduledDateTime.isBefore(DateTime.now())) {
        scheduledDateTime = scheduledDateTime.add(
          const Duration(days: 1),
        ); // Eğer seçilen zaman bugünden önceyse, bir sonraki güne at
      }
      NotificationLogic.scheduleNotification(
        id: index * 1000 + innerIndex, // Benzersiz bir ID oluşturun
        title: 'Hatırlatıcı',
        body: 'Hatırlatma Zamanı Geldi!',
        payload: 'reminder_payload_${index}_${innerIndex}',
        scheduledDateTime: scheduledDateTime,
        categoryIndex: categoryIndex,
      );

      // Firestore'a hatırlatıcı ekleme
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        addReminderToFirestore(
          'Hatırlatıcı',
          'Hatırlatma Zamanı Geldi!',
          scheduledDateTime,
          categoryIndex,
        );
      }
    }
  }
}
