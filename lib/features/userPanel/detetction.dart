import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class DiseaseDetectionApp extends StatefulWidget {
  @override
  _DiseaseDetectionAppState createState() => _DiseaseDetectionAppState();
}

class _DiseaseDetectionAppState extends State<DiseaseDetectionApp> {
  Interpreter? interpreter;
  File? _image;
  bool isModelLoaded = false;
  bool isImageLoaded = false;
  bool isDiseaseDetected = false;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];


  @override
  void initState() {
    setupCamera();
    loadModel().then((value) {
      setState(() {
        isModelLoaded = true;
      });
    });
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

  Future<void> loadModel() async {
    String modelPath = 'assets/your_model.tflite'; // Replace with the path to your trained model
    interpreter = await Interpreter.fromAsset(modelPath);
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

  void detectDisease() async {
    if (interpreter == null || _image == null) {
      print('Model not loaded or image not loaded');
      return;
    }


    var _imageBytes = _image?.readAsBytesSync();
    if (_imageBytes != null) {
      img.Image? image = img.decodeImage(_imageBytes);
      if (image != null) {
        image = img.copyResize(image, width: 224, height: 224);
      }
    }




    // Convert the image to a list of bytes
  //  List<int> imageBytes = image.getBytes();

    // Normalize pixel values to the range [0, 1]

    List<double> normalizedImage = _imageBytes?.map((byte) => byte / 255.0)?.toList() ?? [];

    // List<double> normalizedImage = _imageBytes.map((byte) => byte / 255.0).toList();

    // Reshape the image to match the expected input shape of the model
    var inputShape = interpreter!.getInputTensor(0).shape;
    var outputShape = interpreter!.getOutputTensor(0).shape;

    // Create input buffer
    var inputBuffer = Float32List(inputShape.reduce((a, b) => a * b));

    for (var i = 0; i < normalizedImage.length; i++) {
      inputBuffer[i] = normalizedImage[i];
    }

    // Run inference on the model
    var outputs = Map<int, dynamic>();
    interpreter!.run(inputBuffer, outputs);

    // Get the model's output
    var output = outputs[0] as List<double>;

    // Update the 'isDiseaseDetected' variable based on the output of the model
    setState(() {
      isDiseaseDetected = output[0] > 0.1; // Change this based on your model's output threshold
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                if (_cameraController != null && _cameraController!.value.isInitialized) ...[
                  Container(
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
                  ElevatedButton(
                    onPressed: detectDisease,
                    child: const Text('Detect Disease'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isDiseaseDetected ? 'Disease Detected' : 'No Disease Detected',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
