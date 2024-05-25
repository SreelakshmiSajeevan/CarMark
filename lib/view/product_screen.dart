import 'package:carmark/view/product_detailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,

      ),
      body: StreamBuilder<QuerySnapshot>(
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
            itemCount: snapshot.data!.docs.length,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price: \$${productData['price'] ?? ''}'),
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





// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProductScreen extends StatefulWidget {
//   const ProductScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Products"),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             // Navigate back
//           },
//           child: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No products found.'));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var productData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               return Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Card(
//                   elevation: 15,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Display product image
//                       Image.network(
//                         productData['image'] ?? '',
//                         width: 125.w,
//                         height: 210.h,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(height: 10.h),
//                       // Display product details
//                       ListTile(
//                         title: Text(
//                           '${productData['brand'] ?? ''} ${productData['model'] ?? ''}',
//                           style: TextStyle(fontSize: 18.sp),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Fuel Type: ${productData['fueltype'] ?? ''}'),
//                             Text('Transmission: ${productData['transmission'] ?? ''}'),
//                             Text('Mileage: ${productData['mileage'] ?? ''}'),
//                             Text('Price: \$${productData['price'] ?? ''}'),
//                             // Displaying colors as chips
//                             Wrap(
//                               spacing: 5.w,
//                               children: (productData['color'] as List<dynamic> ?? []).map<Widget>((color) {
//                                 return Chip(
//                                   label: Text(
//                                     color.toString(),
//                                     style: TextStyle(fontSize: 14.sp),
//                                   ),
//                                   backgroundColor: Colors.blue,
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }