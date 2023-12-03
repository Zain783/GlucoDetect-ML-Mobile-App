import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/repository/upload_detection_image.dart';
import 'package:glucoma_app_fyp/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../widgets/rounded_btn.dart';

class DiseaseFormGalleryApp extends StatefulWidget {
  @override
  _DiseaseFormGalleryAppState createState() => _DiseaseFormGalleryAppState();
}

class _DiseaseFormGalleryAppState extends State<DiseaseFormGalleryApp> {
  File? _image;
  bool isImageLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  Future<void> loadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        isImageLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: loadImage,
                child: const Text('Choose Image'),
              ),
              const SizedBox(height: 20),
              if (_image != null) ...[
                Image.file(
                  _image!,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await uploadDetectionImage(
                              image: _image!, context: context);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        text: "Upload Detection Image",
                        isLoading: isLoading),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
