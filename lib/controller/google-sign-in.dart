import 'package:carmark/view/home_page.dart';
import 'package:carmark/view/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usr_model.dart';
import '../view/welcome_screen.dart';

class GoogleController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);

  Future<void> signInWithGoogle() async {
    try {
      // Ensure any previous sign-in is signed out
      await googleSignIn.signOut();

      // Initiate a new sign-in
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;
        await saveSession(true);
        if (user != null) {
          UserModel userModel = UserModel(
            uId: user.uid,
            username: user.displayName.toString(),
            email: user.email.toString(),
            phone: user.phoneNumber.toString(),
            userImg: user.photoURL.toString(),
            country: '',
            userAddress: '',
            createdOn: DateTime.now(),
          );
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toMap());
          Get.offAll(() => const HomePage());
        }
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
      user.value = null; // Update the user state
      await saveSession(false);
      Get.offAll(() => const WelcomeScreen());
      print("User Signed Out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> saveSession(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}
