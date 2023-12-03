import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucoma_app_fyp/Login.dart';
import 'package:glucoma_app_fyp/features/adminPanel/add_doctor.dart';
import 'package:glucoma_app_fyp/features/adminPanel/add_medicine.dart';
import 'package:glucoma_app_fyp/features/adminPanel/user_screen.dart';
import 'package:glucoma_app_fyp/features/adminPanel/view_doctors.dart';
import 'package:glucoma_app_fyp/features/adminPanel/view_medicines.dart';
import 'package:glucoma_app_fyp/utils/global_variables.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(user?.email ?? ''),
              accountName: Text(user?.displayName ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Users'),
              subtitle: const Text('Manage and view user information'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              subtitle: const Text('Configure application settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to the Dashboard!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 140,
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UsersScreen()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/users.jpg",
                                height: 60,
                              ),
                              const Text(
                                "Users",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              const Text(
                                "Manage and view user information",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                10.w,
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddDoctorScreen()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              Icon(Icons.person_add,
                                  size: 60, color: Colors.blue),
                              Text(
                                "Add Doctor",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                "Add a new doctor",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorsProfileScreen()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/doctor_image.jpg",
                                height: 60,
                              ),
                              const Text(
                                "View Doctors",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              const Text(
                                "View all Doctors which we have currently",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.medical_services_outlined,
                    size: 40, color: Colors.blue),
                title: const Text(
                  "Add Medicine",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Add new medicine information"),
                onTap: () {
                  // Handle settings option
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMedicineScreen()),
                  );
                },
              ),
            ),
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.medical_information,
                    size: 40, color: Colors.blue),
                title: const Text(
                  "View Medicine",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("View all medicine information"),
                onTap: () {
                  // Handle settings option
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MedicinesScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
