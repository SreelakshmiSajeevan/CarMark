import 'package:carmark/view/about_page.dart';
import 'package:carmark/view/camera_page.dart';
import 'package:carmark/view/google_mapsample.dart';
import 'package:carmark/view/notifications_page.dart';
import 'package:carmark/view/support_page.dart';
import 'package:carmark/view/upload_fire.dart';
import 'package:flutter/material.dart';
import 'package:carmark/view/profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                shape: OutlineInputBorder(),
                child: ListTile(
                  shape: OutlineInputBorder(),
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text("Account"),
                  trailing: Icon(Icons.arrow_right_alt),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                shape: OutlineInputBorder(),
                elevation: 10,
                child: ListTile(
                  shape: OutlineInputBorder(),
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  trailing: Icon(Icons.arrow_right_alt),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutPage(),
                        ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                shape: OutlineInputBorder(),
                child: ListTile(
                  shape: OutlineInputBorder(),
                  leading: Icon(Icons.notification_important),
                  title: Text("Notifications"),
                  trailing: Icon(Icons.arrow_right_alt),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(),
                        ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Card(
                elevation: 10,
                shape: OutlineInputBorder(),
                child: ListTile(
                  shape: OutlineInputBorder(),
                  leading: Icon(Icons.help_outline),
                  title: Text("Help and Support"),
                  trailing: Icon(Icons.arrow_right_alt),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportPage(),
                        ));
                  },
                ),
              ),
            ),

          ],
        ));
  }
}
