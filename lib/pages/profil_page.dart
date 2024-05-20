import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_diet_app/pages/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController kiloController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController targetKiloController = TextEditingController();

  late String kilo = '';
  late String gender = '';
  late String size = '';
  late String name = '';
  late String age = '';
  late String targetKilo = '';

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userSnapshot.exists) {
          final data = userSnapshot.data() as Map<String, dynamic>?;

          setState(() {
            name = data?['name'] ?? '';
            kilo = data?['kilo']?.toString() ?? '';
            gender = data?['gender'] ?? '';
            size = data?['size']?.toString() ?? '';
            age = data?['age']?.toString() ?? '';
            targetKilo = data?['targetKilo']?.toString() ?? '';

            nameController.text = name;
            kiloController.text = kilo;
            genderController.text = gender;
            sizeController.text = size;
            ageController.text = age;
            targetKiloController.text = targetKilo;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
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
            _buildHeader(),
            const SizedBox(height: 20),
            _buildInfoRow('Kilo', kilo),
            _buildInfoRow('Boy', size),
            _buildInfoRow('Yaş', age),
            _buildInfoRow('Cinsiyet', gender),
            const SizedBox(height: 20),
            _buildEditButton(),
            const SizedBox(height: 20),
            _buildTargetCard(),
            const SizedBox(height: 10),
            _buildSetTargetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 35),
            const SizedBox(width: 10),
            Text(name, style: const TextStyle(fontSize: 30)),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
          icon: const Icon(Icons.settings, size: 35),
        ),
      ],
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        _showEditDialog();
      },
      child: const Text('Bilgileri Düzenle'),
    );
  }

  void _showEditDialog() {
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
                  decoration: const InputDecoration(labelText: 'Kilo'),
                ),
                TextFormField(
                  controller: sizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Boy'),
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Yaş'),
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
  }

  Widget _buildTargetCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Hedef',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    semanticsLabel: '50%',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kilo, style: const TextStyle(fontSize: 16)),
                    Text(targetKilo.isNotEmpty ? targetKilo : 'Hedef',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetTargetButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: () {
          _showSetTargetDialog();
        },
        child: const Text('Yeni Hedef Belirle'),
      ),
    );
  }

  void _showSetTargetDialog() {
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
                  decoration: const InputDecoration(labelText: 'Yeni Hedef'),
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
  }

  Future<void> _saveUserData() async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'kilo': kilo,
          'size': size,
          'age': age,
        });
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
  }

  Future<void> _saveTargetKilo() async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'targetKilo': targetKilo});
      } catch (e) {
        print("Error saving target kilo: $e");
      }
    }
  }
}
