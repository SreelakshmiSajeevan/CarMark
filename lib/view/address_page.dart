import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carmark/view/payment_page.dart';

class AddressPage extends StatefulWidget {
  final String? orderId;

  const AddressPage({Key? key, this.orderId}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String? _address, _pincode, _state, _houseno, _city, _roadname;
  Position? _position;

  final _formKey = GlobalKey<FormState>();

  TextEditingController pinCodeController = TextEditingController();
  TextEditingController housenoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController roadnameController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  Future<bool> checkPermissionPhone() async {
    bool isLocationEnabled;
    LocationPermission permission;
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location is disabled, please enable your location")));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Location is disabled")));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location permission are permanently denied")));
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    final hasPermission = await checkPermissionPhone();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _position = position;
        _getAddressFromLatLng(_position!);
      });
    }).catchError((e) {});
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_position!.latitude, _position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _address =
        '${place.street}, ${place.subLocality}, ${place.postalCode}, ${place.administrativeArea},${place.name}';
        _pincode = place.postalCode;
        _houseno = place.name;
        _roadname = place.street;
        _city = place.subLocality;
        _state = place.administrativeArea;
        housenoController.text = _houseno.toString();
        roadnameController.text = _roadname.toString();
        cityController.text = _city.toString();
        stateController.text = _state.toString();
        pinCodeController.text = _pincode.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  String? _validateHouseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your house number';
    }
    return null;
  }


  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your city';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your state';
    }
    return null;
  }

  String? _validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your pincode';
    }
    return null;
  }

  Future<void> saveAddress() async {
    if (widget.orderId != null) {
      await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
        'address': {
          'houseNo': housenoController.text,
          'roadName': roadnameController.text,
          'city': cityController.text,
          'state': stateController.text,
          'pinCode': pinCodeController.text,
        }
      });

      // Fetch the total amount from the orders collection
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
      if (orderSnapshot.exists) {
        double totalAmount = orderSnapshot['totalAmount'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address saved successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage(
            userId: FirebaseAuth.instance.currentUser!.uid,
            orderId: widget.orderId!,
            houseNo: housenoController.text,
            roadName: roadnameController.text,
            city: cityController.text,
            state: stateController.text,
            pinCode: pinCodeController.text,
            totalAmount: totalAmount,  // Pass the total amount to the PaymentPage
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_address != null)
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10.0),
              //   child: Text(
              //     _address!,
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: housenoController,
                            decoration: InputDecoration(
                              labelText: "House Number",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateHouseNumber,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: "City",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateCity,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: stateController,
                            decoration: InputDecoration(
                              labelText: "State",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateState,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: pinCodeController,
                            decoration: InputDecoration(
                              labelText: "Pincode",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validatePinCode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: getCurrentLocation,
                  child: Text("Use My Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveAddress();
                    }
                  },
                  child: Text("Save Address"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
