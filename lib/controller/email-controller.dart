import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../model/usr_model.dart';
import '../view/welcome_screen.dart';

class EmailController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool passwordVisible = true.obs;
  RxBool loading = false.obs;

  void updateLoading() {
    loading.toggle();
  }

  void updateVisibility() {
    passwordVisible.toggle();
  }

  FirebaseAuth get auth => _auth;

  Future<void> signupUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      bool isEmailRegistered = await isEmailAlreadyRegistered(email);
      if (!isEmailRegistered) {
        String newName = name.split(' ')
            .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
            .join(' ');

        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.updateEmail(email);
        UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userCredential.user!.displayName ?? name,
          email: userCredential.user!.email ?? '',
          phone: userCredential.user!.phoneNumber ?? '',
          userImg: userCredential.user!.photoURL ??
              'https://firebasestorage.googleapis.com/v0/b/dealninja-2b50b.appspot.com/o/User.png?alt=media&token=b2e7d3ec-7ff6-4567-84b5-d9cee26253f2',
          country: 'NA',
          userAddress: 'NA',
          createdOn: DateTime.now(),
        );
        try {
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
        } catch (e) {
          print("Error saving user data: $e");
        }
      } else {
        print("Email already registered!");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }


  User? get currentUser => _auth.currentUser;
  String errorMessage = '';

  Future<UserCredential?> signinUser(String userEmail, String userPassword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      await saveSession(true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user Found with this Email');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Password did not match');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> forgotPassword(String userEmail) async {
    try {
      // Check if the email exists in Firestore
      bool isEmailRegistered = await isEmailAlreadyRegistered(userEmail);

      if (isEmailRegistered) {
        // If the email exists, send the password reset email
        await _auth.sendPasswordResetEmail(email: userEmail);
        Get.snackbar(
          "Request Sent Successfully",
          "Password reset link sent to $userEmail",
          snackPosition: SnackPosition.TOP,
        );
        Get.off(const WelcomeScreen(), transition: Transition.leftToRightWithFade);
      } else {
        // If the email doesn't exist, show an error message
        Get.snackbar(
          "Error",
          "No user found with this email",
          snackPosition: SnackPosition.TOP,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "An error occurred",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
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
