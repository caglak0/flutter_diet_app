import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_diet_app/pages/nearby_pharmacies_page.dart';
import 'package:flutter_diet_app/pages/nearby_hospitals_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? _profileImage;
  final String _profileImageName = "profile_image.jpg";
=======
import 'package:flutter_diet_app/main.dart';
import 'package:flutter_diet_app/screens/good_bye_screen.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.userId});
  final String userId;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late String name = '';
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _profileImageName);
    if (File(path).existsSync()) {
      setState(() {
        _profileImage = path;
      });
=======
    fetchUserData(); // initState içinde çağırın
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
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
<<<<<<< HEAD
          GestureDetector(
            onTap: () {
              _getImage();
            },
            child: UserAccountsDrawerHeader(
              accountName: const Text('Kullanıcı Adı'),
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
=======
          UserAccountsDrawerHeader(
            accountName: Text(name),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
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
                image: AssetImage('assets/back.jpg'),
              ),
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_pharmacy_outlined),
            title: const Text('Nöbetçi Eczane'),
<<<<<<< HEAD
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
=======
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital_outlined),
            title: const Text('Hastane'),
            onTap: () {},
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
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba
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
<<<<<<< HEAD
            leading: const Icon(Icons.nights_stay_outlined),
            title: const Text('Görünüm'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Çıkış'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {},
=======
            leading: SizedBox(
              width: 20,
              child: IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  onPressed: () {},
                  icon: const Icon(Icons.exit_to_app)),
            ),
            title: const Text('Çıkış Yap'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoodByePage(),
                ),
              );
            },
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
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
=======
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
>>>>>>> 6fa08eb04ca5dbf2da2a23975cd948aaeadfeeba
  }
}
