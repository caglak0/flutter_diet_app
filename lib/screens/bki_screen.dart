import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/home_screen.dart';
import 'package:flutter_diet_app/widgets/custom_scaffold.dart';

class BkiScreen extends StatelessWidget {
  final int kilo;
  final int boy;
  final int yas;
  final String cinsiyet;

  const BkiScreen({
    super.key,
    required this.kilo,
    required this.boy,
    required this.yas,
    required this.cinsiyet,
  });

  @override
  Widget build(BuildContext context) {
    double bki = kilo / ((boy / 100) * (boy / 100));
    String bkiDurumu = '';

    if (bki > 25) {
      bkiDurumu = 'Fazla kilolu olarak kabul ediliyorsunuz.';
    } else if (bki >= 18.5 && bki <= 24.9) {
      bkiDurumu = 'Normal kilolu olarak kabul ediliyorsunuz.';
    } else {
      bkiDurumu = 'Zayıf olarak kabul ediliyorsunuz.';
    }

    double idealKiloErkek = 50 + 2.3 * ((boy / 2.54) - 60);
    double idealKiloKadin = 45.5 + 2.3 * ((boy / 2.54) - 60);
    String idealKiloDurumu = '';

    if (cinsiyet == 'Erkek') {
      idealKiloDurumu = 'İdeal kilonuz ${idealKiloErkek.toStringAsFixed(2)} kg';
    } else {
      idealKiloDurumu =
          'İdeal kilonuz: ${idealKiloKadin.toStringAsFixed(2)} kg';
    }

    return CustomScaffold(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Beden Kitle İndeksi Sonucu',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 52, 120, 54)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'BKI Değeriniz ${bki.toStringAsFixed(2)} çıkmıştır.',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                bkiDurumu,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                idealKiloDurumu,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavbarTheme(),
                      ),
                    );
                  },
                  child: const Text(
                    'Hadi Başla!',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
