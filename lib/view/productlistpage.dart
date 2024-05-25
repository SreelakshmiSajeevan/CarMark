import 'package:carmark/view/product_detailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductListPage extends StatelessWidget {
  final String brand;

  const ProductListPage({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('brand', isEqualTo: brand)
            .get(),
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
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var productData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: (){
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text('Fuel Type: ${productData['fueltype'] ?? ''}'),
                              //Text('Transmission: ${productData['transmission'] ?? ''}'),
                              // Text('Mileage: ${productData['mileage'] ?? ''}'),
                              Text('Price: \$${productData['price'] ?? ''}'),
                              // Displaying colors as chips
                              // Wrap(
                              //   spacing: 5.w,
                              //   children: (productData['color'] as List<dynamic> ?? []).map<Widget>((color) {
                              //     return Chip(
                              //       label: Text(
                              //         color.toString(),
                              //         style: TextStyle(fontSize: 14.sp),
                              //       ),
                              //       backgroundColor: Colors.blue,
                              //     );
                              //   }).toList(),
                              // ),
                            ],
                          ),
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
    );
  }
}