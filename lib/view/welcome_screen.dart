import 'package:flutter/material.dart';
import 'package:carmark/view/signin_screen.dart';
import 'package:carmark/view/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child:
                    Image.asset('images/welcomescreen.jpg', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signin(),
                      ));
                },
                child: const Text('Sign In'),
              ),
            ),
            Positioned(
              right: 20.0,
              bottom: 20.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Signup(),));
                },
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
