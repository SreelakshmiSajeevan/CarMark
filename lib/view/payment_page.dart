import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/razor_credentials.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final String houseNo;
  final String roadName;
  final String city;
  final String state;
  final String pinCode;
  final double totalAmount;
  final String userId; // Added userId field

  const PaymentPage({
    Key? key,
    required this.orderId,
    required this.houseNo,
    required this.roadName,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.totalAmount,
    required this.userId, // Added userId parameter
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? userEmail;
  String? userPhone;

  Future<void> fetchUserDetails() async {
    try {
      // Query Firestore for user details using userId
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      // Extract email and phone number from the user document
      setState(() {
        userEmail = userSnapshot['email'];
        userPhone = userSnapshot['phoneNumber'];
      });
    } catch (e) {
      debugPrint('Error fetching user details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    fetchUserDetails();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckOut() async {
    const double usdToInrRate = 75.0; // Replace with actual exchange rate or API call

    // Convert totalAmount from USD to INR
    int amountInPaise = (widget.totalAmount * usdToInrRate * 100).toInt(); // Amount in paise
    double twentyPercent = amountInPaise *20/100;
    var options = {
      'key': RazorPayCredentials.keyId,
      'amount': amountInPaise, // Amount in paise
      'currency': 'INR',
      'name': 'Jim Mathew',
      'description': 'Description for order',
      'timeout': 60,
      'prefill': {
        'contact': userPhone ?? '', // Use userPhone fetched from Firestore
        'email': userEmail ?? '', // Use userEmail fetched from Firestore
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Success: ' + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Error: ' + response.message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet: ' + response.walletName!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RazorPay Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    openCheckOut();
                  }
                },
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
