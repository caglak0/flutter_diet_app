import 'package:flutter/material.dart';
import 'package:flutter_diet_app/main.dart';
import 'package:flutter_diet_app/screens/welcome_page.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Kullanıcı Adı'),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(
              child: Image.asset(
                'assets/profil.jpg',
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            )),
            accountEmail: null,
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/back.jpg')),
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
            onTap: () {},
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
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
                  builder: (context) => const WelcomePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
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
