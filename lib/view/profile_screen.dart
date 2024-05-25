import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/get-user-data-controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User user;
  late List<QueryDocumentSnapshot<Object?>> userData = [];
  Future<Map<String, dynamic>?>? addressFuture;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _getUserData();
    addressFuture = _getLatestOrder();
  }

  Future<void> _getUserData() async {
    var userDataController = Get.put(GetUserDataController());
    userData = await userDataController.getUserData(user.uid);
    if (mounted) {
      setState(() {});
    }
  }

  Future<Map<String, dynamic>?> _getLatestOrder() async {
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (ordersSnapshot.docs.isNotEmpty) {
      DocumentSnapshot latestOrder = ordersSnapshot.docs.first;
      Map<String, dynamic>? orderData = latestOrder.data() as Map<String, dynamic>?;
      if (orderData != null && orderData.containsKey('address')) {
        return orderData['address'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 90.r,
                backgroundImage: NetworkImage(
                  userData.isNotEmpty && userData[0]['userImg'] != null && userData[0]['userImg'].isNotEmpty
                      ? userData[0]['userImg']
                      : 'https://via.placeholder.com/150',
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(15.0).r,
                child: Card(
                  elevation: 15,
                  shape: OutlineInputBorder(),
                  child: ListTile(
                    title: Text(
                      "${userData.isNotEmpty ? userData[0]['username'] : 'N/A'}",
                    ),
                    leading: Icon(Icons.account_circle_outlined),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0).r,
                child: Card(
                  shape: OutlineInputBorder(),
                  elevation: 15,
                  child: ListTile(
                    title: Text(
                      "${userData.isNotEmpty ? userData[0]['email'] : 'N/A'}",
                    ),
                    leading: Icon(Icons.email),
                  ),
                ),
              ),

              // Address Information
              FutureBuilder<Map<String, dynamic>?>(
                future: addressFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data == null) {
                    return Center(child: Text('No address found.'));
                  }
                  Map<String, dynamic>? addressData = snapshot.data;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0).r,
                        child: Card(
                          elevation: 15,
                          shape: OutlineInputBorder(),
                          child: ListTile(
                            title: Text(
                              "House Number: ${addressData!['houseNo'] ?? 'N/A'}",
                            ),
                            leading: Icon(Icons.home),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0).r,
                        child: Card(
                          elevation: 15,
                          shape: OutlineInputBorder(),
                          child: ListTile(
                            title: Text(
                              "Landmark: ${addressData['roadName'] ?? 'N/A'}",
                            ),
                            leading: Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0).r,
                        child: Card(
                          elevation: 15,
                          shape: OutlineInputBorder(),
                          child: ListTile(
                            title: Text(
                              "City: ${addressData['city'] ?? 'N/A'}",
                            ),
                            leading: Icon(Icons.location_city),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0).r,
                        child: Card(
                          elevation: 15,
                          shape: OutlineInputBorder(),
                          child: ListTile(
                            title: Text(
                              "State: ${addressData['state'] ?? 'N/A'}",
                            ),
                            leading: Icon(Icons.map),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0).r,
                        child: Card(
                          elevation: 15,
                          shape: OutlineInputBorder(),
                          child: ListTile(
                            title: Text(
                              "Pincode: ${addressData['pinCode'] ?? 'N/A'}",
                            ),
                            leading: Icon(Icons.pin_drop),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
