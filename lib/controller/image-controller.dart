import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchbrandImages();

  }

  // Creating RxList to store image URLs from Firestore
  RxList<String> BrandImages = RxList<String>([]);
  RxList<String> brandNames = RxList<String>([]);

  // Method to fetch carosel images from Firestore collection
  fetchbrandImages() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('brand-images').get();
      if (snapshot.docs.isNotEmpty) {
        List<String> images = [];
        List<String> names = []; // Renamed the brand names list to avoid conflict
        snapshot.docs.forEach((doc) {
          String imageUrl = doc['image'] as String;
          String brandName = doc['brand'] as String;
          images.add(imageUrl);
          names.add(brandName);
        });
        BrandImages.value = images;
        brandNames.value = names; // Assign the names to the brandNames RxList
      }
    } catch (e) {
      print('Error fetching brand images: $e'); // Log the error for debugging
    }
  }

}