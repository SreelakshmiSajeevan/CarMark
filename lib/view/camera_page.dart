// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key}) : super(key: key);
//
//   @override
//   CameraScreenState createState() => CameraScreenState();
// }
//
// class CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   late List<CameraDescription> _cameras;
//   late CameraDescription _firstCamera;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     _cameras = await availableCameras();
//     _firstCamera = _cameras.first;
//     _controller = CameraController(
//       _firstCamera,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture')),
//       body: _controller == null
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             final image = await _controller.takePicture();
//
//             if (!context.mounted) return;
//
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(imagePath: image.path),
//               ),
//             );
//           } catch (e) {
//             print(e);
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
//
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
