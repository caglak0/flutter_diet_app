import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/barcode.dart';
import 'package:google_fonts/google_fonts.dart';

class BarkodScanner extends StatelessWidget {
  const BarkodScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final BarcodeScannerService barcodeScannerService = BarcodeScannerService();

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
                    onPressed: () async {
                      String result =
                          await barcodeScannerService.scanBarcodeNormal();
                    },
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
                                return const Divider(
                                    color: Colors.grey, height: 40);
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
