import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareOptionsPage extends StatelessWidget {
  const ShareOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('SMS ile paylaş'),
            onTap: () {
              Navigator.pop(context);
              Share.share('Arkadaşlarını davet et!',
                  subject: 'Arkadaşını Davet Et');
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('WhatsApp ile paylaş'),
            onTap: () {
              Navigator.pop(context);
              Share.share('Arkadaşlarını davet et!',
                  subject: 'Arkadaşını Davet Et');
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Bağlantıyı kopyala'),
            onTap: () {
              Navigator.pop(context);
              Share.share('Arkadaşlarını davet et!',
                  subject: 'Arkadaşını Davet Et');
            },
          ),
        ],
      ),
    );
  }
}
