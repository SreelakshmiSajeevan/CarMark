import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Terms and Conditions

Effective Date: [05/18/2024]

Welcome to CarMark. By using our app, you agree to comply with and be bound by the following terms and conditions. Please review these terms carefully.

1. Acceptance of Terms:
   - By accessing and using CarMark, you accept and agree to be bound by these Terms and Conditions.

2. Use of the App:
   - You agree to use CarMark for lawful purposes only. You must not use our app in any way that may cause harm to others or the app itself.

3. User Accounts:
   - When you create an account with CarMark, you must provide accurate and complete information. You are responsible for maintaining the confidentiality of your account and password.

4. Intellectual Property:
   - All content and materials available on CarMark, including but not limited to text, graphics, logos, and software, are the property of CarMark and are protected by applicable intellectual property laws.

5. Termination:
   - We reserve the right to terminate or suspend your account and access to CarMark at our sole discretion, without notice, for conduct that we believe violates these Terms and Conditions or is harmful to other users of the app, us, or third parties.

6. Limitation of Liability:
   - CarMark is provided "as is" and "as available" without any warranties of any kind. We do not warrant that the app will be uninterrupted, error-free, or free from viruses or other harmful components.

7. Changes to Terms:
   - We may update these Terms and Conditions from time to time. We will notify you of any changes by posting the new Terms and Conditions on this page.

8. Governing Law:
   - These Terms and Conditions are governed by and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law principles.

If you have any questions about these Terms and Conditions, please contact us at blackjack1915@gmail.com.

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
