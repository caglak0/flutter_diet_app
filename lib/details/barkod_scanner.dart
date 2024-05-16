import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/barcode.dart';

class BarkodScanner extends StatelessWidget {
  const BarkodScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final BarcodeScannerService barcodeScannerService = BarcodeScannerService();

    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              String result = await barcodeScannerService.scanBarcodeNormal();
            },
            label: const Text('Barkod Tarayıcı'),
            icon: const Icon(Icons.camera_alt_outlined),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
