import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/anasayfa_page.dart';

class NavbarTheme extends StatefulWidget {
  const NavbarTheme({super.key});

  @override
  State<NavbarTheme> createState() => _NavbarThemeState();
}

class _NavbarThemeState extends State<NavbarTheme>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final double _notchedMargin = 10;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _MyTabViews.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _MyTabViews.values.length,
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 102, 195, 106),
          child: const Icon(
            Icons.smart_toy_outlined,
            size: 35,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: _notchedMargin,
          shape: const CircularNotchedRectangle(),
          child: _mytabBar(),
        ),
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.menu, size: 30)),
              const SizedBox(width: 10),
              const Text(
                'BUGÜN',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30,
                    )),
              ],
            ),
          ],
        ),
        body: _tabBarView(),
      ),
    );
  }

  void _navigateToAnasayfaPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AnasayfaPage(),
    ));
  }

  TabBar _mytabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        InkWell(
          onTap: _navigateToAnasayfaPage,
          child: const Tab(
            icon: Icon(
              Icons.home,
              size: 35,
            ),
          ),
        ),
        const Tab(
          icon: Icon(
            Icons.qr_code_scanner,
            size: 35,
          ),
        ),
        const Tab(
          icon: Icon(Icons.person, size: 35),
        ),
        const Tab(
          icon: Icon(Icons.settings, size: 35),
        ),
      ],
    );
  }

  TabBarView _tabBarView() {
    return TabBarView(
      controller: _tabController,
      children: _MyTabViews.values.map((view) => _buildTabView(view)).toList(),
    );
  }

  Widget _buildTabView(_MyTabViews view) {
    switch (view) {
      case _MyTabViews.anasayfa:
        return const Center(
          child: Text('Anasayfa'),
        );
      case _MyTabViews.adimSayar:
        return const Center(
          child: Text('Barkod Tarayıcı'),
        );
      case _MyTabViews.barkodTarayici:
        return const Center(
          child: Text('Profil'),
        );
      case _MyTabViews.profil:
        return const Center(
          child: Text('Ayarlar'),
        );
    }
  }
}

enum _MyTabViews { anasayfa, adimSayar, barkodTarayici, profil }
