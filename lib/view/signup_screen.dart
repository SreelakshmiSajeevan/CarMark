import 'package:flutter/material.dart';
import 'package:carmark/view/signin_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/email-controller.dart';
import '../controller/google-sign-in.dart';
import 'email-validation-screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _ispasswordvisible = true;
  var emailedit = TextEditingController();
  var passedit = TextEditingController();
  var nameedit = TextEditingController();
  final onekey = GlobalKey<FormState>();
  var emailpattern = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
  var namepattern = RegExp(r'^[a-zA-Z]+ [a-zA-Z]+$');
  var passpattern = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~])[a-zA-Z\d!@#$%^&*()_+{}\[\]:;<>,.?~]{8,12}$');
  final GoogleController _googleSignInController = Get.put(GoogleController());
  final EmailController _emailPassController = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: onekey,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create a New Account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 25),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please Fill in the form to continue",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                child: TextFormField(
                  controller: nameedit,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter name");
                    } else if (!namepattern.hasMatch(value)) {
                      return 'Please enter first and last name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                child: TextFormField(
                  controller: emailedit,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter email");
                    } else if (!emailpattern.hasMatch(value)) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                child: TextFormField(
                  controller: passedit,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter a password");
                    } else if (!passpattern.hasMatch(value)) {
                      return 'Please enter a password thats 8-12 characters with'
                          'one uppercase letter,special character and number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.account_circle),
                    suffixIcon: _ispasswordvisible
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _ispasswordvisible = !_ispasswordvisible;
                              });
                            },
                            icon: const Icon(Icons.visibility))
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _ispasswordvisible = !_ispasswordvisible;
                              });
                            },
                            icon: const Icon(Icons.visibility_off)),
                  ),
                  obscureText: _ispasswordvisible,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: SizedBox(
                width: 160.w,
                height: 40.h,
                child: ElevatedButton(
                    onPressed: () async {
                      if (onekey.currentState!.validate()) {
                        _emailPassController.updateLoading();
                        try {
                          await _emailPassController.signupUser(
                            emailedit.text,
                            passedit.text,
                            nameedit.text,
                          );
                          if (_emailPassController.currentUser != null) {
                            Get.off(
                                () => EmailValidationScreen(
                                    user: _emailPassController.currentUser!),
                                transition: Transition.leftToRightWithFade);
                          } else {
                            // No user is currently authenticated
                            Get.snackbar(
                                'No user is', 'currently authenticated');
                          }
                        } catch (e) {
                          Get.snackbar('Error', e.toString());
                        } finally {
                          _emailPassController.updateLoading();
                        }
                      }
                    },
                    child: const Text("Sign up")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signin(),
                            ));
                      },
                      child: const Text("Sign in")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
