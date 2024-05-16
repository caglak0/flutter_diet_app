import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_diet_app/models/nobetci_eczane_model.dart';
import 'package:flutter_diet_app/services/nobetci_eczane_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPharmaciesPage extends StatefulWidget {
  const NearbyPharmaciesPage({super.key});

  @override
  _NearbyPharmaciesPageState createState() => _NearbyPharmaciesPageState();
}

class _NearbyPharmaciesPageState extends State<NearbyPharmaciesPage> {
  final NobetciEczaneService eczaneService = NobetciEczaneService();
  List<NobetciEczane> eczaneler = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchPharmacies();
  }

  void _getLocationAndFetchPharmacies() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<NobetciEczane> response = await eczaneService.getEczane(
            position.latitude, position.longitude);

        setState(() {
          eczaneler = response;
          isLoading = false;
        });
      } catch (e) {
        print("Hata: $e");
        _showErrorSnackbar('Eczaneler getirilemedi.');
      }
    } else if (permission == LocationPermission.denied) {
      _showPermissionSnackbar('Konum izni verilmedi.');
    } else {
      _showPermissionSnackbar('Konum izni bekleniyor...');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Tamam',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showPermissionSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Ayarlar',
          onPressed: () {
            Geolocator.openAppSettings();
          },
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adres panoya kopyalandı.'),
      ),
    );
  }

  void _launchMaps(String address) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Haritalar uygulaması açılamıyor: $url';
    }
  }

  void _callPharmacy(String phoneNumber) async {
    try {
      await launch('tel:$phoneNumber');
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Telefon araması başlatılamıyor: $phoneNumber'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Nöbetçi Eczane Bilgileri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 4,
                color: isLoading ? Colors.blue : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Konum Bilgilerine Göre Eczaneler Listelendi:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Toplam ${eczaneler.length} adet eczane bulundu.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eczaneler[index].pharmacyName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                            children: [
                              
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _launchMaps(eczaneler[index].address ?? '');
                                  },
                                  child: Text(
                                    eczaneler[index].address ?? '',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  _copyToClipboard(
                                      eczaneler[index].address ?? '');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Telefon: ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _callPharmacy(eczaneler[index].phone ?? '');
                                },
                                child: Text(
                                  '${eczaneler[index].phone ?? ''}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kapanış Saati: ${eczaneler[index].pharmacyDutyEnd ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Uzaklık: ${eczaneler[index].distanceKm} km',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: eczaneler.length,
            ),
          ),
        ],
      ),
    );
  }
}
