import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'address_page.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _showProductDetails = false;
  double _totalAmount = 0.0;
  bool _isBooked = false;
  bool _isFavorite = false;
  String? _userUid;
  String? _orderId;

  @override
  void initState() {
    super.initState();
    fetchUserUid();
    fetchFavoriteStatus();
  }

  Future<void> fetchUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userUid = user?.uid;
    });
  }

  Future<void> fetchFavoriteStatus() async {
    if (_userUid == null) return;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('is-favorite')
          .doc('${_userUid}_${widget.productData['pid']}')
          .get();

      if (snapshot.exists) {
        setState(() {
          _isFavorite = snapshot['isFavorite'] ?? false;
        });
      }
    } catch (error) {
      print('Error fetching favorite status: $error');
      setState(() {
        _isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      widget.productData['image1'] ?? '',
      widget.productData['image2'] ?? '',
      widget.productData['image3'] ?? '',
      widget.productData['image4'] ?? '',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (imageUrls.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: imageUrls.map((item) => Container(
                  child: Center(
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 1000,
                      )),
                )).toList(),
              )
            else
              Text('No images available'),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.productData['brand'] ?? ''} ${widget.productData['model'] ?? ''}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // IconButton(
                //   onPressed: () async {
                //     setState(() {
                //       _isFavorite = !_isFavorite;
                //     });
                //     if (_userUid != null) {
                //       await FirebaseFirestore.instance
                //           .collection('is-favorite')
                //           .doc('${_userUid}_${widget.productData['pid']}')
                //           .set({
                //         'uid': _userUid,
                //         'pid': widget.productData['pid'],
                //         'isFavorite': _isFavorite,
                //       });
                //     }
                //   },
                //   icon: Icon(
                //     _isFavorite ? Icons.favorite : Icons.favorite_border,
                //     color: _isFavorite ? Colors.red : null,
                //   ),
                // ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });

                    if (_userUid != null) {
                      if (_isFavorite) {
                        // Add to Firestore
                        await FirebaseFirestore.instance
                            .collection('is-favorite')
                            .doc('${_userUid}_${widget.productData['pid']}')
                            .set({
                          'uid': _userUid,
                          'pid': widget.productData['pid'],
                          'isFavorite': _isFavorite,
                        });
                      } else {
                        // Remove from Firestore
                        await FirebaseFirestore.instance
                            .collection('is-favorite')
                            .doc('${_userUid}_${widget.productData['pid']}')
                            .delete();
                      }
                    }
                  },
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.productData['price'] ?? ''}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Description: ${widget.productData['description'] ?? ''}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('Fuel Type: ${widget.productData['fueltype'] ?? ''}'),
            SizedBox(height: 10),
            Text('Transmission: ${widget.productData['transmission'] ?? ''}'),
            SizedBox(height: 10),
            Text('Mileage: ${widget.productData['mileage'] ?? ''}'),
            SizedBox(height: 20),
            if (_showProductDetails)
              ProductDetailsCard(
                productData: widget.productData,
                totalAmount: _totalAmount,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 70,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _isBooked ? Colors.grey : Colors.green.shade700,
                    ),
                    onPressed: _isBooked
                        ? null
                        : () async {
                      setState(() {
                        _showProductDetails = true;
                        _isBooked = true;
                      });
                      await placeOrderAndGetTotalAmount(
                          widget.productData, context);
                    },
                    child: Text(
                      'Book Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _isBooked ? Colors.green.shade700 : Colors.grey,
                    ),
                    onPressed: _isBooked
                        ? () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressPage(orderId: _orderId),
                        ),
                      );
                    }
                        : null,
                    child: Text(
                      'Address',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> placeOrderAndGetTotalAmount(
      Map<String, dynamic> productData, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    double price = double.parse(productData['price'].toString());
    double salesTax = 0.025;
    double totalAmount = price * (1 + salesTax);

    final orderCollection = FirebaseFirestore.instance.collection('orders');

    final querySnapshot =
    await orderCollection.where('pid', isEqualTo: productData['pid']).get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already purchased this item.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _showProductDetails = false;
      });
    } else {
      final docRef = await orderCollection.add({
        ...productData,
        'totalAmount': totalAmount,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _totalAmount = totalAmount;
        _orderId = docRef.id;
        _showProductDetails = true;
      });

      print('Product added to orders successfully!');
    }
  }
}

class ProductDetailsCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final double totalAmount;

  const ProductDetailsCard({
    Key? key,
    required this.productData,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Invoice",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "CarMark",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Brand/Model : ${productData['brand'] ?? ''} ${productData['model'] ?? ''}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Price: \$${productData['price'] ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Sales Tax: 2.5%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }
}
