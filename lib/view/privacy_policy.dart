import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Privacy Policy

Effective Date: [05/18/2024]

Welcome to CarMark. We value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our app.

1. Information We Collect:
   - Personal Information: When you register for CarMark, we may collect personal information such as your name, email address, and phone number.
   - Usage Data: We collect information on how you use the app, such as the features you use and the time spent on the app.
   - Device Information: We collect information about the device you use to access CarMark, including your device's IP address, operating system, and browser type.

2. How We Use Your Information:
   - To Provide and Maintain Our Service: We use your information to operate and maintain CarMark.
   - To Communicate with You: We may use your information to send updates, notifications, and other information related to your use of the app.
   - To Improve Our Service: We analyze usage data to improve the functionality and user experience of CarMark.

3. Information Sharing:
   - We do not sell or share your personal information with third parties except as necessary to provide our service or as required by law.

4. Security:
   - We implement appropriate security measures to protect your data from unauthorized access, alteration, or disclosure.

5. Your Rights:
   - You have the right to access, update, or delete your personal information. You can do this by contacting us at blackjack1915@gmail.com.

6. Changes to This Privacy Policy:
   - We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

If you have any questions about this Privacy Policy, please contact us at blackjack1915@gmail.com.

Thank you for using CarMark.

Sincerely,
The CarMark Team
            ''',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
