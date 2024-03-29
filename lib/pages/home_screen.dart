import 'package:flutter/material.dart';
import 'package:flutter_diet_app/details/step_count.dart';
import 'package:flutter_diet_app/details/water.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
                    )),
              ],
            ),
          ],
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
          icon: Icon(Icons.wysiwyg_rounded, size: 35),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(cardTitle), // Kart başlığı burada kullanılıyor
              content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Arama yapın',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Kapat'),
                ),
              ],
            );
          },
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
    switch (view) {
      case _MyTabViews.anasayfa:
        return ListView(padding: const EdgeInsets.only(bottom: 200), children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RadialGraph(context: context),
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
                const LinearProgressInCard(
                  progressValue: 0.5,
                ),
              ],
            ),
          ),
        ]);
      case _MyTabViews.adimSayar:
        return const Center(
          child: Text('Adım Sayar'),
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

class _RadialGraph extends StatelessWidget {
  const _RadialGraph({
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 3,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            pointers: const [
              RangePointer(
                value: 50,
                width: 35,
                cornerStyle: CornerStyle.bothCurve,
                color: Colors.orange,
                gradient: SweepGradient(
                    colors: [Color(0xFFFFC434), Color(0xFFFF8209)],
                    stops: [0.1, 0.75]),
              )
            ],
            axisLineStyle: const AxisLineStyle(
                thickness: 35, color: Color.fromARGB(255, 201, 193, 193)),
            startAngle: 5,
            endAngle: 5,
            showLabels: false,
            showTicks: false,
            annotations: const [
              GaugeAnnotation(
                widget: Text(
                  '50%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                angle: 270,
                positionFactor: 0.1,
              )
            ],
          ),
        ],
      ),
    );
  }
}

enum _MyTabViews { anasayfa, adimSayar, barkodTarayici, profil }
