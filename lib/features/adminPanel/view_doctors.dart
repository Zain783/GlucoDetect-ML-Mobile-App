import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsProfileScreen extends StatefulWidget {
  @override
  _DoctorsProfileScreenState createState() => _DoctorsProfileScreenState();
}

class _DoctorsProfileScreenState extends State<DoctorsProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    // You can use the doctor's profile image here if available
                    radius: 30,
                    backgroundImage: NetworkImage(doctor['image_url'] ?? ''),
                  ),
                  title: Text(doctor['name']),
                  subtitle: Text(doctor['description']),
                  onTap: () {
                    // Navigate to the detailed profile page or perform any other action
                    // You can pass the doctor data to the detailed profile page
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
