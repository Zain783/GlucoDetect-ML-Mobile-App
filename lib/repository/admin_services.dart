import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/utils/utils.dart';

class AdminServices {
  Future<void> addDoctor(
      {required String name,
      required String contact,
      required String description,
      required String email,
      required String city,
      required File image,
      required BuildContext context}) async {
    try {
      if (image == null) {
        return;
      }
      // Upload the image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('doctor_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putFile(image);

      // Get the download URL of the uploaded image
      final String imageUrl = await storageReference.getDownloadURL();

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Add doctor details to Firestore
      await FirebaseFirestore.instance.collection('doctors').add({
        'name': name,
        'contact': contact,
        'description': description,
        'email': email,
        'city': city,
        'image_url': imageUrl,
        'added_by': user?.uid,
      });

      Utils.showSnakBar(context, 'Doctor added successfully');
    } catch (e) {
      print('Error adding doctor: $e');
      // Handle the error as needed
    }
  }

  Future<void> addMedicine(
      {required String name,
      required String description,
      required File image,
      required BuildContext context}) async {
    try {
      if (image == null) {
        return;
      }
      // Upload the image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('medicine_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putFile(image);

      // Get the download URL of the uploaded image
      final String imageUrl = await storageReference.getDownloadURL();

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Add doctor details to Firestore
      await FirebaseFirestore.instance.collection('midicines').add({
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'added_by': user?.uid,
      });

      Utils.showSnakBar(context, 'Medicine added successfully');
    } catch (e) {
      print('Error adding Medicine: $e');
      // Handle the error as needed
    }
  }
}
