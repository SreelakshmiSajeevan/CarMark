import 'package:carmark/controller/google-sign-in.dart';
import 'package:carmark/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carmark/view/forgot_pass.dart';
import 'package:carmark/view/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../controller/email-controller.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _ispasswordvisible = true;
  var useredit = TextEditingController();
  var passedit = TextEditingController();
  final onekey = GlobalKey<FormState>();
  var userpattern = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
  var passwordpattern = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~])[a-zA-Z\d!@#$%^&*()_+{}\[\]:;<>,.?~]{8,12}$');
  GoogleController googleController=Get.put(GoogleController());
  EmailController emailController = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: onekey,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome Back !",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        )),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please sign in ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100.h,
                ),
                Card(
                  elevation: 10,
                  child: TextFormField(
                    controller: useredit,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please enter email");
                      } else if (!userpattern.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Card(
                  elevation: 10,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please enter a password");
                      } else if (!passwordpattern.hasMatch(value)) {
                        return 'Please enter a password thats 8-12 characters with'
                            'one uppercase letter,special character and number';
                      }
                      return null;
                    },
                    controller: passedit,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      border: const OutlineInputBorder(),
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
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _ispasswordvisible,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ));
                        },
                        child: const Text("Forgot password?")),
                  ],
                ),
                SizedBox(
                  width: 160.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (onekey.currentState!.validate()) {
                        emailController.updateLoading();
                        try {
                          UserCredential? userCredential =
                          await emailController.signinUser(
                            useredit.text,
                            passedit.text,
                          );
                          if (userCredential != null &&
                              userCredential.user!.emailVerified) {
                            final user = userCredential.user;
                            Get.offAll(() => const HomePage(),
                                transition: Transition.leftToRightWithFade);
                          }
                        } catch (e) {
                          print(e);
                          Get.snackbar('Error', emailController.errorMessage);
                        } finally {
                          emailController.updateLoading();
                        }
                      } else {
                        // Display the error message in a snackbar if there is one
                        Get.snackbar('Error', emailController.errorMessage);
                      }
                    },
                    child: const Text("Sign in"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0).r,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SignInButton(
                          buttonType: ButtonType.google,
                          buttonSize: ButtonSize.medium, // small(default), medium, large
                          onPressed: () async{
                            await googleController.signInWithGoogle();
                          })
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Dont have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ));
                          },
                          child: const Text("Sign up")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
