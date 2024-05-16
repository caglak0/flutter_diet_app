import 'package:flutter/material.dart';
import 'package:flutter_diet_app/details/barkod_scanner.dart';
import 'package:flutter_diet_app/details/radial_graph.dart';
import 'package:flutter_diet_app/details/step_radial.dart';
import 'package:flutter_diet_app/details/water.dart';
import 'package:flutter_diet_app/pages/analiz_page.dart';
import 'package:flutter_diet_app/pages/asistan_app.dart';
import 'package:flutter_diet_app/pages/profil_page.dart';
import 'package:flutter_diet_app/pages/search_page.dart';
import 'package:flutter_diet_app/pages/side_menu.dart';

class NavbarTheme extends StatefulWidget {
  const NavbarTheme({super.key});

  @override
  State<NavbarTheme> createState() => _NavbarThemeState();
}

class _NavbarThemeState extends State<NavbarTheme>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final double _notchedMargin = 10;
  List<IconData> icons = [];

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
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
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
        body: _tabBarView(),
      ),
    );
  }

  TabBar _mytabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(
          icon: Icon(
            Icons.home,
            size: 35,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.qr_code_scanner,
            size: 35,
          ),
        ),
        Tab(
          icon: Icon(Icons.folder_copy_outlined, size: 35),
        ),
        Tab(
          icon: Icon(Icons.person, size: 35),
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

  Widget _buildCardWidget(String title, String cardTitle) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(title: cardTitle),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 150,
            height: 140,
            child: Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabView(_MyTabViews view) {
    String greeting;
    var hour = DateTime.now().hour;
    if (hour < 5) {
      greeting = 'İyi Geceler 💤';
    } else if (hour < 12) {
      greeting = 'Günaydın ☀️';
    } else if (hour < 18) {
      greeting = 'İyi Öğlenler ✨';
    } else {
      greeting = 'İyi Akşamlar 🌙';
    }
    switch (view) {
      case _MyTabViews.anasayfa:
        return Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
            title: Text(
              greeting,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null) {
                        print('Seçilen tarih: ${pickedDate.toIso8601String()}');
                      }
                    },
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
                    ),
                  ),
                ],
              ),
            ],
          ),
          body:
              ListView(padding: const EdgeInsets.only(bottom: 200), children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadialGraph(context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCardWidget("Kahvaltı 🍳", "Kahvaltı 🍳"),
                      _buildCardWidget("Ara Öğün 🥗", "Ara Öğün 🥗")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCardWidget("Öğle Yemeği 🥐", "Öğle Yemeği 🥐"),
                      _buildCardWidget("Akşam Yemeği 🍕", "Akşam Yemeği 🍕"),
                    ],
                  ),
                  const WaterCard(),
                  const SizedBox(height: 5),
                  const StepRadial()
                ],
              ),
            ),
          ]),
        );
      case _MyTabViews.barkodTarayici:
        return const Column(children: [Expanded(child: BarkodScanner())]);
      case _MyTabViews.analiz:
        return const Column(
          children: [Expanded(child: AnalizScreen())],
        );
      case _MyTabViews.profil:
        return const Column(
          children: [Expanded(child: ProfileScreen())],
        );
    }
  }
}

enum _MyTabViews { anasayfa, barkodTarayici, analiz, profil }
