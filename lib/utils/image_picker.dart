// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerUtils {
//   static Future<Uint8List?> pickImage(BuildContext context) async {
//     Uint8List? image;

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Upload Image"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.pop(context);
//                     final Uint8List? file =
//                         await _pickImageFromSource(ImageSource.camera);
//                     if (file != null) {
//                       image ;
//                     }
//                   },
//                   child: const Text("Take a photo"),
//                 ),
//                 const SizedBox(height: 16.0),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.pop(context);
//                     final Uint8List? file =
//                         await _pickImageFromSource(ImageSource.gallery);
//                     if (file != null) {
//                       image = file;
//                     }
//                   },
//                   child: const Text("Choose from Gallery"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     return image;
//   }

//   static Future<Uint8List?> _pickImageFromSource(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       final Uint8List fileBytes = await pickedFile.readAsBytes();
//       return fileBytes;
//     }

//     return null;
//   }
// }
