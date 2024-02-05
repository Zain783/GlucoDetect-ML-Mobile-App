import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class UserViewDoctorsScreen extends StatefulWidget {
  @override
  _UserViewDoctorsScreenState createState() => _UserViewDoctorsScreenState();
}

class _UserViewDoctorsScreenState extends State<UserViewDoctorsScreen> {
  late TextEditingController _searchController;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getCurrentLocation();
  }

  double _currentDistance = 5.0;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_currentDistance km'),
                Slider(
                  value: _currentDistance,
                  min: 0.0,
                  max: 40.0,
                  divisions: 40,
                  onChanged: (double value) {
                    setState(() {
                      _currentDistance = value;
                    });
                  },
                ),
                Text('$_currentDistance km'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by doctor name or city',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (value) {
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

                    // Check if the search bar is empty or the doctor matches the search query
                    if (_searchController.text.isEmpty ||
                        (doctor['name'].toString().toLowerCase().contains(
                                _searchController.text.toLowerCase()) ||
                            doctor['city'].toString().toLowerCase().contains(
                                _searchController.text.toLowerCase()))) {
                      double doctorDistance = _calculateDistance(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                        doctor['latitude'],
                        doctor['longitude'],
                      );
                      if (doctorDistance <= _currentDistance) {
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
                              _launchEmail(doctor['email']);
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
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

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371.0; // Earth radius in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  void _launchEmail(String? email) async {
    if (email != null && await canLaunch('mailto:$email')) {
      await launch('mailto:$email');
    } else {
      print('Could not launch email');
    }
  }
}
