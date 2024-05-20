import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepCounterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveStepCount(int stepCount) async {
    final String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(uid);

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
              .serverTimestamp(), 
        });
      } else {
        await userDocRef
            .collection('step_counts')
            .doc(_getTodayDateString())
            .set({
          'step_count': stepCount,
          'last_updated': FieldValue
              .serverTimestamp(), 
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
