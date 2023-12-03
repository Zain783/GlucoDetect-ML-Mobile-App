import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/widgets/rounded_btn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../repository/upload_detection_image.dart';
import '../../utils/utils.dart';

class DiseaseDetectionApp extends StatefulWidget {
  @override
  _DiseaseDetectionAppState createState() => _DiseaseDetectionAppState();
}

class _DiseaseDetectionAppState extends State<DiseaseDetectionApp> {
  File? _image;
  bool isModelLoaded = false;
  bool isImageLoaded = false;
  bool isDiseaseDetected = false;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    setupCamera();

    super.initState();
  }

  Future<void> setupCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> loadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        isImageLoaded = true;
        isDiseaseDetected = false;
      });
    }
  }

  bool isLoading = false;

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
                child: const Text('Capture Image'),
              ),
              const SizedBox(height: 20),
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized) ...[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CameraPreview(_cameraController!),
                ),
              ],
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
