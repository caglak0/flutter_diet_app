import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepCounterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveStepCount(int stepCount) async {
    // Kullanıcının UID'sini al
    final String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      // Firestore'da kullanıcıya özgü bir belge referansı oluştur
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(uid);

      // Firestore'da bugünün tarihine göre bir belge oluştur veya varsa mevcut belgeyi al
      final DocumentSnapshot snapshot = await userDocRef
          .collection('step_counts')
          .doc(_getTodayDateString())
          .get();

      if (snapshot.exists) {
        // Var olan belgeyi güncelle
        await userDocRef
            .collection('step_counts')
            .doc(_getTodayDateString())
            .update({
          'step_count': stepCount,
          'last_updated': FieldValue
              .serverTimestamp(), // Sunucu saatine göre güncellenme tarihini ekleyin
        });
      } else {
        // Yeni bir belge oluştur
        await userDocRef
            .collection('step_counts')
            .doc(_getTodayDateString())
            .set({
          'step_count': stepCount,
          'last_updated': FieldValue
              .serverTimestamp(), // Sunucu saatine göre oluşturma ve güncellenme tarihini ekleyin
        });
      }
    }
  }

  String _getTodayDateString() {
    final DateTime now = DateTime.now();
    return '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
