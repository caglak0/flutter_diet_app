import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String kilo = '';
  late String gender = '';
  late String size = '';
  late String name = '';
  late String age = '';
  late String targetKilo = '';

  TextEditingController kiloController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController targetKiloController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      final data = userSnapshot.data() as Map<String, dynamic>?;

      setState(() {
        kilo = data != null && data.containsKey('kilo')
            ? data['kilo'].toString()
            : '';
        gender = data != null && data.containsKey('gender')
            ? data['gender'].toString()
            : '';
        size = data != null && data.containsKey('size')
            ? data['size'].toString()
            : '';
        name = data != null && data.containsKey('name')
            ? data['name'].toString()
            : '';
        age = data != null && data.containsKey('age')
            ? data['age'].toString()
            : '';
        targetKilo = data != null && data.containsKey('targetKilo')
            ? data['targetKilo'].toString()
            : '';

        kiloController.text = kilo;
        genderController.text = gender;
        sizeController.text = size;
        nameController.text = name;
        ageController.text = age;
        targetKiloController.text = targetKilo;
      });
    } catch (e) {
      print("Firestore'dan verileri alırken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 35,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen(
                                userId: 'SJqXeILPd8RpGOmEJl3A',
                              )),
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Kilo', kilo),
            _buildInfoRow('Boy', size),
            _buildInfoRow('Yaş', age),
            _buildInfoRow('Cinsiyet', gender),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Bilgileri Düzenle'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: kiloController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Kilo'),
                            ),
                            TextFormField(
                              controller: sizeController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Boy'),
                            ),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Yaş'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('İptal'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              kilo = kiloController.text;
                              size = sizeController.text;
                              age = ageController.text;
                            });
                            await _saveUserData();
                            Navigator.pop(context);
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Bilgileri Düzenle'),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Hedef',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                          child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                            semanticsLabel: '50%',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              kilo,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              targetKilo.isNotEmpty ? targetKilo : 'Hedef',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Yeni Hedef Belirle'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              TextFormField(
                                controller: targetKiloController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Yeni Hedef'),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('İptal'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                targetKilo = targetKiloController.text;
                              });
                              await _saveTargetKilo();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Kaydet'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Yeni Hedef Belirle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Future<void> _saveUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'kilo': kiloController.text,
        'size': sizeController.text,
        'age': ageController.text,
      });
    } catch (e) {
      print("Veritabanına kaydetme işlemi başarısız oldu: $e");
    }
  }

  Future<void> _saveTargetKilo() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'targetKilo': targetKiloController.text,
      });
    } catch (e) {
      print("Veritabanına kaydetme işlemi başarısız oldu: $e");
    }
  }
}
