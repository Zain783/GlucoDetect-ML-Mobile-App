// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Login.dart';
import '../features/adminPanel/dashboard_screen.dart';
import '../main.dart';
import '../utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await _firestore.collection('users').doc(user?.uid).set(
          {'email': email, 'name': name, 'role': "user", 'userId': user!.uid});

      // ignore: use_build_context_synchronously
      Utils.snackBar("Account created successfully", context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(
                    title: '',
                  )));
    } catch (e) {
      Utils.snackBar(e.toString(), context);
      print("Error in signUpWithEmailAndPassword: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // Check the user's role here
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Assuming you have a 'role' field in your user document
        String role = userData['role'];

        // Navigate based on the user's role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(
                      title: "",
                    )),
          );
        }
      }

      Utils.snackBar("Login successful", context);
    } catch (e) {
      Utils.snackBar(e.toString(), context);
      print("Error in signInWithEmailAndPassword: $e");
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.snackBar("Password reset email sent. Check your inbox.", context);
    } catch (e) {
      Utils.snackBar("Error sending password reset email: $e", context);
      print("Error in resetPassword: $e");
    }
  }

  // Method to log out the user
  Future<void> signOut(BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      await _auth.signOut();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      print("Error in signOut: $e");
    }
  }
}
