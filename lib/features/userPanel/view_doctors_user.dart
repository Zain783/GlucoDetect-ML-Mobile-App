import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UserViewDoctorsScreen extends StatefulWidget {
  @override
  _UserViewDoctorsScreenState createState() => _UserViewDoctorsScreenState();
}

class _UserViewDoctorsScreenState extends State<UserViewDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
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
                    radius: 30,
                    backgroundImage: NetworkImage(doctor['image_url'] ?? ''),
                  ),
                  title: Text(doctor['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor['description']),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(width: 4),
                              Text(doctor['email'] ?? 'No Email'),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 4),
                              Text(doctor['contact'] ?? 'No Phone'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    // You can add custom logic here when a doctor is tapped
                    _launchEmail(doctor['email']);
                    // or
                    // _launchPhone(doctor['phone']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _launchEmail(String? email) async {
    if (email != null && await canLaunch('mailto:$email')) {
      await launch('mailto:$email');
    } else {
      // Handle the case where the email cannot be launched
      print('Could not launch email');
    }
  }

  void _launchPhone(String? phone) async {
    if (phone != null && await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      // Handle the case where the phone number cannot be launched
      print('Could not launch phone');
    }
  }
}
