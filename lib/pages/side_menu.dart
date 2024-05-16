import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
            leading: const Icon(Icons.credit_card),
            title: const Text('Hesap Tipi'),
            onTap: () {},
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
            leading: const Icon(Icons.nights_stay_outlined),
            title: const Text('Görünüm'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Çıkış'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {},
          ),
        ],
      ),
    );
  }

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
  }
}
