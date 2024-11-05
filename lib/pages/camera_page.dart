import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _imageFile; // Holds the captured image

  // Method to capture an image using the camera
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Save the image file path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the captured image if available
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Text(
                    'No image captured',
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureImage,
              child: const Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}
