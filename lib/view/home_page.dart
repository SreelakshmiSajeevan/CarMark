import 'package:cached_network_image/cached_network_image.dart';
import 'package:carmark/controller/carosel-controller.dart';
import 'package:carmark/controller/image-controller.dart';
import 'package:carmark/view/orders_page.dart';
import 'package:carmark/view/product_detailpage.dart';
import 'package:carmark/view/productlistpage.dart';
import 'package:carmark/view/profile_screen.dart';
import 'package:carmark/view/settings_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carmark/view/product_screen.dart';
import 'package:carmark/view/signin_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/get-user-data-controller.dart';
import '../controller/google-sign-in.dart';
import 'favorites_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleController googleSignInController = GoogleController();
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());

  late final User user;
  late List<QueryDocumentSnapshot<Object?>> userData = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _getUserData();
  }

  Future<void> _getUserData() async {
    userData = await _getUserDataController.getUserData(user.uid);
    if (mounted) {
      setState(() {});
    }
  }

  //Creating object for caroselcontroller to get carosel images from firestore
  CaroselController caroselController = Get.put(CaroselController());
  int currentindex = 0;
  ImageController imageController = Get.put(ImageController());
  int imageindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
              backgroundColor: Colors.white30,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
              backgroundColor: Colors.white30,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          onTap: (int index) {
            // Handle navigation based on the tapped index
            switch (index) {
              case 0:
                // Navigate to the Home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
              case 1:
                // Navigate to the Favorites screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
                break;
              case 2:
                // Navigate to the Orders screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
                break;
              case 3:
                // Navigate to the Settings screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                break;
            }
          },
        ),
        drawer: Drawer(
          elevation: 10,
          child: SafeArea(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 90.r,
                  backgroundImage: NetworkImage(
                    userData.isNotEmpty &&
                            userData[0]['userImg'] != null &&
                            userData[0]['userImg'].isNotEmpty
                        ? userData[0]['userImg']
                        : 'https://via.placeholder.com/150', // Placeholder URL for testing
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0).r,
                  child: ListTile(
                    title: Text("Order History"),
                    leading: Icon((Icons.shopping_cart)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage(),));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0).r,
                  child: ListTile(
                    title: Text("Products"),
                    leading: Icon(Icons.shopping_basket_outlined),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(),
                          ));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0).r,
                  child: ListTile(
                    title: Text("Profile"),
                    leading: Icon(Icons.home_outlined),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));


                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0).r,
                  child: ListTile(
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      await googleSignInController.signOutGoogle();
                      print(
                          "*************** Logged out **************************************");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Obx(
              () {
                if (caroselController.caroselImages.isEmpty) {
                  return Shimmer.fromColors(
                    child: CircularProgressIndicator(),
                    baseColor: Colors.grey,
                    highlightColor: Colors.black38,
                  );
                } else {
                  return CarouselSlider.builder(
                    itemCount: caroselController.caroselImages.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          caroselController.caroselImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 290.h,
                        scrollDirection: Axis.horizontal,
                        disableCenter: true,
                        autoPlay: true),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0).r,
              child: Center(
                child: Text(
                  "Brands",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Handle onTap for the first image
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).r,
                      child: Container(
                        height: 70.h,
                        child: Obx(() {
                          if (imageController.BrandImages.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageController.BrandImages.length,
                              // Display half of the images
                              itemBuilder: (BuildContext context, int index) {
                                String selectedBrandName =
                                    imageController.brandNames[
                                        index]; // Accessing brandNames RxList

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductListPage(
                                            brand: selectedBrandName),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Image.network(
                                        imageController.BrandImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Center(
              child: Text("Best Sellers",style: TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(
                top: 35
            ),
              child: SizedBox(
                width: 375,
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No products found.'));
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        var productData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            // Navigate to detail page with product details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(productData: productData),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Card(
                              color: Colors.white,
                              elevation: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display product image
                                  Image.network(
                                    productData['image1'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 10.h),
                                  // Display product details
                                  ListTile(
                                    title: Text(
                                      '${productData['brand'] ?? ''} ${productData['model'] ?? ''}',
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                    // subtitle: Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text('Price: \$${productData['price'] ?? ''}'),
                                    //   ],
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  },
                ),
              ),
            ),
          ]),
        ));
  }
}
