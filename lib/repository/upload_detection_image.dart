import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/utils.dart';

Future<void> uploadDetectionImage(
    {required File image, required BuildContext context}) async {
  try {
    if (image == null) {
      return;
    }
    // Upload the image to Firebase Storage
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('detection_history/${DateTime.now().millisecondsSinceEpoch}');
    await storageReference.putFile(image);

    // Get the download URL of the uploaded image
    final String imageUrl = await storageReference.getDownloadURL();

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Add Detection details to Firestore
    await FirebaseFirestore.instance.collection('detection_history').add({
      'prediction': "",
      'image_url': imageUrl,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "timestamp": FieldValue.serverTimestamp()
    });
    await preditionApi(imageUrl, context);
    // Utils.showSnakBar(context, 'Detection Image Uploaded');
  } catch (e) {
    print('Error adding Medicine: $e');
    // Handle the error as needed
  }
}

Future<void> preditionApi(String imageUrl, BuildContext context) async {
  String urladdress = "http://127.0.0.1:8000/predict";
  //final response = await http.get(Uri.parse("http://10.0.2.2:8000"));
  try {
    final response = await http.post(
      Uri.parse(urladdress),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        "Connection": "keep-alive"
      },
      body: jsonEncode({"image": imageUrl}),
    );
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Utils.snackBar(json.decode(response.body)["class"], context);
      await updateDetectionStatus(
          prediction: json.decode(response.body)["class"]);
    } else {
      // ignore: use_build_context_synchronously
      Utils.errorSnakbar(context, "some erro occured in api");
    }
  } catch (e) {
    // Handle potential errors like network issues.
    print('Error: $e');
    throw Exception('Failed to post data');
  }
}

Future<void> updateDetectionStatus({required String prediction}) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('detection_history')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference
          .update({'prediction': prediction});
    }
  } catch (e) {
    print('Error updating detection status: $e');
    // Handle the error as needed
  }
}
