import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn.instance;

  // ==============================
  // LOGIN GOOGLE
  // ==============================
  Future<User?> signInWithGoogle() async {
    try {
      await _google.initialize();

      final GoogleSignInAccount googleUser = await _google.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await FirestoreService().saveUser(
          uid: user.uid,
          name: user.displayName ?? "Pengguna",
          email: user.email ?? "",
        );
      }

      print("✅ Login Google berhasil");
      return user;
    } catch (e) {
      print("❌ ERROR GOOGLE: $e");
      return null;
    }
  }

  // ==============================
  // REGISTER EMAIL & PASSWORD
  // ==============================
  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // Simpan nama di Firebase Authentication
        await user.updateDisplayName(name);

        // Simpan data ke Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": name,
          "email": email,
          "phone": phone,
          "role": "user",
          "createdAt": FieldValue.serverTimestamp(),
        });

        print("✅ Register berhasil");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("❌ REGISTER ERROR: ${e.code}");
      return null;
    } catch (e) {
      print("❌ REGISTER ERROR: $e");
      return null;
    }
  }

  // ==============================
  // LOGIN EMAIL & PASSWORD
  // ==============================
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      print("✅ Login Email berhasil");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("❌ LOGIN ERROR: ${e.code}");
      return null;
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
      return null;
    }
  }

  // ==============================
  // LOGOUT
  // ==============================
  Future<void> logout() async {
    try {
      await _google.disconnect();
    } catch (e) {
      print("Google disconnect: $e");
    }

    await _google.signOut();
    await _auth.signOut();

    print("✅ Logout berhasil");
  }
}
