import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaroselController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  // Creating RxList to store image URLs from Firestore
  RxList<String> caroselImages = RxList<String>([]);

  // Method to fetch carosel images from Firestore collection
  fetchImages() async {
    try {
      // Connecting to collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('carosel-slider')
          .get();

      // Check if the collection is not empty
      if (snapshot.docs.isNotEmpty) {
        caroselImages.value = snapshot.docs
            .map((document) => document['image'] as String)
            .toList();
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

}