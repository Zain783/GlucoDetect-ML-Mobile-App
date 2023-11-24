import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class DiseaseApp extends StatefulWidget {
  @override
  _DiseaseAppState createState() => _DiseaseAppState();
}

class _DiseaseAppState extends State<DiseaseApp> {
  Interpreter? interpreter;
  File? _image;
  bool isModelLoaded = false;
  bool isImageLoaded = false;
  bool isDiseaseDetected = false;

  @override
  void initState() {
    loadModel().then((value) {
      setState(() {
        isModelLoaded = true;
      });
    });
    super.initState();
  }

  Future<void> loadModel() async {
    String modelPath =
        'assets/your_model.tflite'; // Replace with the path to your trained model
    interpreter = await Interpreter.fromAsset(modelPath);
  }

  Future<void> loadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

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

  // Preprocess the input image
  var _imageBytes = _image?.readAsBytesSync();

  if (_imageBytes != null) {
    img.Image? image = img.decodeImage(_imageBytes);

    if (image != null) {
      // Resize image to the expected input size (224x224)
      image = img.copyResize(image, width: 224, height: 224);

      // Normalize pixel values to the range [0, 1]
      List<double> normalizedImage = List<double>.from(
          image.getBytes().map<double>((byte) => (byte & 0xFF) / 255.0));

      // Create input buffer
      var inputBuffer = Float32List(1 * 224 * 224 * 3);

      for (int i = 0; i < 224; i++) {
        for (int j = 0; j < 224; j++) {
          for (int k = 0; k < 3; k++) {
            inputBuffer[i * 224 * 3 + j * 3 + k] = normalizedImage[(i * 224 + j) * 3 + k];
          }
        }
      }

      // Print dimensions and values for debugging
      print('Input Shape: ${interpreter!.getInputTensor(0).shape}');
      print('Expected Input Size: ${interpreter!.getInputTensor(0).shape.reduce((a, b) => a * b)}');
      print('Dimensions of inputBuffer: ${inputBuffer.length}');
      print('First 10 values of inputBuffer: ${inputBuffer.sublist(0, 10)}');

      // Add batch dimension
      var input = [inputBuffer];

      try {
        // Run inference on the model
        var outputs = Map<int, dynamic>();
        interpreter!.run(input, outputs);

        // Get the model's output
        var output = outputs[0] as List<double>;

        // Print output for debugging
        print('Model Output: $output');

        // Update the 'isDiseaseDetected' variable based on the output of the model
        setState(() {
          isDiseaseDetected = output[0] > 0.1; // Change this based on your model's output threshold
        });
      } catch (e) {
        print('Error running inference: $e');
      }
    }
  }
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
                  child: const Text('Choose Image'),
                ),
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
                    isDiseaseDetected
                        ? 'Disease Detected'
                        : 'No Disease Detected',
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
