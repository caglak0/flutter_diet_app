import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_diet_app/model/barcode_model.dart';
import 'package:flutter_diet_app/pages/barcode.dart';
import 'package:flutter_diet_app/pages/food_detail_page.dart';
import 'package:flutter_diet_app/service/food_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarkodScanner extends StatefulWidget {
  const BarkodScanner({Key? key}) : super(key: key);

  @override
  _BarkodScannerState createState() => _BarkodScannerState();
}

class _BarkodScannerState extends State<BarkodScanner> {
  final BarcodeScannerService barcodeScannerService = BarcodeScannerService();
  final TextEditingController _barcodeController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> _selectedFoods = {
    'Kahvaltı': [],
    'Ara Öğün': [],
    'Öğle Yemeği': [],
    'Akşam Yemeği': [],
  };

  void _addFood(String mealType, String name, double calories, int quantity) {
    setState(() {
      _selectedFoods[mealType]!.add({'name': name, 'calories': calories, 'quantity': quantity});
      _saveSelectedFoods();
    });
  }

  Future<void> _saveSelectedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFoods.forEach((key, value) {
      prefs.setString('${key}Foods', json.encode(value));
    });
  }

  void _removeFood(String mealType, int index) {
    setState(() {
      _selectedFoods[mealType]!.removeAt(index);
      _saveSelectedFoods();
    });
  }

  void _fetchFoodDetails(String barcode) async {
    try {
      BarcodeModel barcodeModel = await FatSecretService.foodByBarcodeService(barcode);
      String foodId = barcodeModel.foodId?.value ?? '';
      if (foodId.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailView(
              foodId: foodId,
              onAddFood: (name, calories, quantity) => _addFood('Ara Öğün', name, calories, quantity),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu barkod için yiyecek bulunamadı'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBarcodeScan() async {
    String result = await barcodeScannerService.scanBarcodeNormal();
    _fetchFoodDetails(result);
  }

  void _onManualSubmit() {
    String barcode = _barcodeController.text;
    if (barcode.isNotEmpty) {
      _fetchFoodDetails(barcode);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir barkod girin'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Yediğin ürünlerin besin değerlerini görmek için lütfen dene',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onBarcodeScan,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 184, 242, 186),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Icon(Icons.camera_alt, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barkod Numarası Girin',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _onManualSubmit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Gönder'),
              ),
              const SizedBox(height: 80),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Kendime Not',
                      style: GoogleFonts.alexBrush(
                        textStyle: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return const Divider(color: Colors.grey, height: 40);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
