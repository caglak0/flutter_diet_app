import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diet_app/main.dart';
import 'package:flutter_diet_app/pages/%C4%B1nvite_friends_page.dart';
import 'package:flutter_diet_app/screens/good_bye_screen.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late String name = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        setState(() {
          name = userSnapshot.get('name').toString();
        });
      }
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
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_pharmacy_outlined),
            title: const Text('Nöbetçi Eczane'),
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
            onTap: () {
              _showShareOptions(context);
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: SizedBox(
              width: 20,
              child: IconButton(
                padding: const EdgeInsets.only(right: 20),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoodByePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ),
            title: const Text('Çıkış Yap'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
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

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ShareOptionsPage();
      },
    );
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
