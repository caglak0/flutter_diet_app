import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/nearby_pharmacies_page.dart';
import 'package:flutter_diet_app/pages/nearby_hospitals_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_diet_app/main.dart';
import 'package:flutter_diet_app/screens/good_bye_screen.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? _profileImage;
  final String _profileImageName = "profile_image.jpg";
  late String name = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    fetchUserData(); // initState içinde çağırın
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _profileImageName);
    if (File(path).existsSync()) {
      setState(() {
        _profileImage = path;
      });
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Firestore'dan oturum açmış kullanıcının UID'sini al
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Firestore'dan kullanıcı belgesini al
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      setState(() {
        name = userSnapshot.get('name').toString();
      });
    } catch (e) {
      print("Firestore'dan verileri alırken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              _getImage();
            },
            child: UserAccountsDrawerHeader(
              accountName: Text(name.isEmpty ? 'Kullanıcı Adı' : name),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(
                          File(_profileImage!),
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        )
                      : Image.asset(
                          'assets/profil.jpg',
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ),
                ),
              ),
              accountEmail: null,
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/back.jpg'), // Arka plan resmi sabit
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_pharmacy_outlined),
            title: const Text('Nöbetçi Eczane'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyPharmaciesPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital_outlined),
            title: const Text('Hastane'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyHospitalsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: SizedBox(
              width: 20,
              child: IconButton(
                padding: const EdgeInsets.only(right: 20),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: themeProvider.currentTheme == LighTema().theme
                    ? const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.black,
                        size: 25,
                      )
                    : const Icon(
                        Icons.wb_sunny,
                        color: Colors.yellow,
                        size: 25,
                      ),
              ),
            ),
            title: const Text('Tema'),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Hesap Tipi'),
            onTap: () {
              _showPremiumDialog(context);
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Aydınlatma Metni'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Arkadaşlarını Davet Et'),
            onTap: () {},
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Çıkış'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoodByePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, _profileImageName);

      // Save the selected image to the application documents directory
      final file = File(pickedFile.path);
      await file.copy(path);

      setState(() {
        _profileImage = path;
      });
    }
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hesap Tipi'),
          content:
              const Text('Hesabınızı Premium\'a yükseltmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Premium Ol'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Vazgeç'),
            ),
          ],
        );
      },
    );
  }
}
