import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();
  final TextEditingController _cinsiyetController = TextEditingController();
  final TextEditingController _bkiController = TextEditingController();

  String? _selectedCinsiyet; // Seçilen cinsiyeti saklamak için değişken eklendi

  late FocusNode _boyNode;
  late FocusNode _yasNode;
  late FocusNode _cinsiyetNode;
  late FocusNode _bkiNode;

  @override
  void initState() {
    super.initState();
    _boyNode = FocusNode();
    _yasNode = FocusNode();
    _cinsiyetNode = FocusNode();
    _bkiNode = FocusNode();
  }

  @override
  void dispose() {
    _kiloController.dispose();
    _boyController.dispose();
    _yasController.dispose();
    _cinsiyetController.dispose();
    _bkiController.dispose();
    _boyNode.dispose();
    _yasNode.dispose();
    _cinsiyetNode.dispose();
    _bkiNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Oluşturma'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    'Adınız',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _kiloController,
                decoration: const InputDecoration(labelText: 'Kilo'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_boyNode);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _boyController,
                focusNode: _boyNode,
                decoration: const InputDecoration(labelText: 'Boy'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_yasNode);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _yasController,
                focusNode: _yasNode,
                decoration: const InputDecoration(labelText: 'Yaş'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cinsiyetNode);
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cinsiyet'),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCinsiyet = value;
                  });
                },
                items: <String>['Erkek', 'Kadın']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _bkiController,
                focusNode: _bkiNode,
                decoration: const InputDecoration(labelText: 'BKİ'),
                onFieldSubmitted: (_) {
                  // Buraya isterseniz son alanın sonrasındaki işlemi yazabilirsiniz.
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Hedef',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
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
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Başlangıç',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Hedef',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Yeni Hedef Belirle'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                TextFormField(
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
                              onPressed: () {
                                // Yeni hedefi kaydetmek için yapılacak işlemler burada
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
      ),
    );
  }
}
