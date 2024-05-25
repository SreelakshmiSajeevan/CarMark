import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('orders').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final orders = snapshot.data!.docs; // List of QueryDocumentSnapshot
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data() as Map<String, dynamic>;
                // Build your order card widget here
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 15,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              order['image1'] ?? '',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Brand: ${order['brand']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Model: ${order['model']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Total Amount: \$${order['totalAmount'].toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _removeOrder(DocumentReference orderRef) {
    orderRef.delete().then((_) {
      // Order removed successfully
      setState(() {
        // Refresh the UI to reflect the changes
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order removed successfully'),
        ),
      );
    }).catchError((error) {
      // Error occurred while removing order
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove order: $error'),
        ),
      );
    });
  }
}
