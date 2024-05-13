import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  static String message = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?> forgotPassword(String email) async {
    String? res;
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      print("Mail kutunuzu kontrol ediniz");
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        res = "Mail Zaten Kayıtlı.";
      }
    }
    return res;
  }

  Future<void> signInWithGoogle() async {
    User? user;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        user = userCredential.user;

        if (user != null) {
          message = 'Sign in with Google success';
        } else {
          message = 'Failed to sign in with Google';
        }
      } else {
        message = 'Google sign in aborted';
      }
    } catch (e) {
      message = 'Failed to sign in with Google: $e';
    }
  }

  Future<String?> signIn(String email, String password) async {
    String? res;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          res = "Kullanıcı Bulunamadı";
          break;
        case "wrong-password":
          res = "Hatalı Şifre";
          break;
        case "user-disabled":
          res = "Kullanıcı Pasif";
          break;
        default:
          res = "Bilgilerinizi kontrol edip tekrar deneyiniz.";
          break;
      }
    }
    return res;
  }

  Future<String?> signUp(String email, String name, String surname,
      String password, String gender, int kilo, int size, int age) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        await firebaseFirestore.collection("users").add({
          "email": email,
          "name": name,
          "surname": surname,
          "gender": gender,
          "kilo": kilo,
          "size": size,
          "age": age,
        });
      } catch (e) {
        print("$e");
      }
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          res = "Mail Zaten Kayıtlı.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          res = "Geçersiz Mail";
          break;
        default:
          res = "Bir Hata İle Karşılaşıldı, Birazdan Tekrar Deneyiniz.";
          break;
      }
    }
    return res;
  }
}
