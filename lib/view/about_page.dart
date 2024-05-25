import 'package:carmark/view/privacy_policy.dart';
import 'package:carmark/view/terms_page.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About This App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Carmark is designed to provide users with the best experience "
                "for buying and selling cars efficiently. Our goal is to "
                "make your life easier by helping you find the perfect "
                "vehicle and streamline the car purchasing process.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              Text(
                "Version",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "App Version: 1.0.0",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                },
                child: Text(
                  "Read our Privacy Policy",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsConditionsPage()),
                  );
                },
                child: Text(
                  "Read our Terms and Conditions",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
