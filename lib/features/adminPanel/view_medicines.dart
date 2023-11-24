import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicinesScreen extends StatefulWidget {
  @override
  _DoctorsProfileScreenState createState() => _DoctorsProfileScreenState();
}

class _DoctorsProfileScreenState extends State<MedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Medicines'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('midicines').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              var doctor = doctors[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(doctor['image_url'] ?? '', height: 200),
                      Text(doctor['name']),
                      Text(doctor['description'])
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
