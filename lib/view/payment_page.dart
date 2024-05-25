import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../controller/razor_credentials.dart';
class PaymentPage extends StatefulWidget {
  final String orderId;
  final String houseNo;
  final String roadName;
  final String city;
  final String state;
  final String pinCode;
  final double totalAmount;

  const PaymentPage({
    Key? key,
    required this.orderId,
    required this.houseNo,
    required this.roadName,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.totalAmount,
  }) : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckOut(int amount) async {
    var options = {
      'key': RazorPayCredentials.keyId,
      'amount': amount,
      'name': 'Vineeth Venu',
      'description': 'Description for order',
      'timeout': 60,
      'prefill': {
        'contact': '9400377390',
        'email': 'vineeth.venu.mini@gmail.com'
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
              TextFormField(
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount to be paid';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Amount'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    int amount = int.tryParse(amtController.text) ?? 0;
                    openCheckOut(amount);
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
