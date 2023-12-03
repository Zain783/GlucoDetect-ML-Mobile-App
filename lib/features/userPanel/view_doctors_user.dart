import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UserViewDoctorsScreen extends StatefulWidget {
  @override
  _UserViewDoctorsScreenState createState() => _UserViewDoctorsScreenState();
}

class _UserViewDoctorsScreenState extends State<UserViewDoctorsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by doctor name or city',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Adjust the value as needed
                ),
              ),
              onChanged: (value) {
                // Add logic to filter doctors based on the search value
                // You may need to modify the StreamBuilder to include a query
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('doctors').snapshots(),
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

                    // Check if the doctor's name or city contains the search query
                    if (_searchController.text.isNotEmpty &&
                            doctor['name'].toString().toLowerCase().contains(
                                _searchController.text.toLowerCase()) ||
                        doctor['city']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())) {
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(doctor['image_url'] ?? ''),
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
                                  Row(
                                    children: [
                                      const Icon(Icons.location_city),
                                      const SizedBox(width: 4),
                                      Text(doctor['city'] ?? 'NAN'),
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
                    } else {
                      // Return an empty container if the doctor doesn't match the search query
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
        ],
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
