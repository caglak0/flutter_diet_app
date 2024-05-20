import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return "Mail kutunuzu kontrol ediniz";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Mail Zaten Kayıtlı.";
      }
    }
    return null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          await _saveUserData(user);
        }
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        await fetchUserData(user);
        return "success";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "Kullanıcı Bulunamadı";
        case "wrong-password":
          return "Hatalı Şifre";
        case "user-disabled":
          return "Kullanıcı Pasif";
        default:
          return "Bilgilerinizi kontrol edip tekrar deneyiniz.";
      }
    }
    return null;
  }

  Future<String?> signUp(
      String email, String name, String surname, String password, String gender, int kilo, int size, int age) async {
    try {
      final UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;

      if (user != null) {
        await _firebaseFirestore.collection("users").doc(user.uid).set({
          "email": email,
          "name": name,
          "surname": surname,
          "gender": gender,
          "kilo": kilo,
          "size": size,
          "age": age,
        });
        return "success";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "Mail Zaten Kayıtlı.";
        case "invalid-email":
          return "Geçersiz Mail";
        default:
          return "Bir Hata İle Karşılaşıldı, Birazdan Tekrar Deneyiniz.";
      }
    }
    return null;
  }

  Future<void> _saveUserData(User user) async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(user.uid).get();

    if (!userSnapshot.exists) {
      await _firebaseFirestore.collection('users').doc(user.uid).set({
        "email": user.email,
        "name": user.displayName ?? '',
        "surname": '',
        "gender": '',
        "kilo": 0,
        "size": 0,
        "age": 0,
      });
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(User user) async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(user.uid).get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
