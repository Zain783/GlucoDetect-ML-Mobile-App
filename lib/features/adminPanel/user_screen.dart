import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Users",
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text('Error fetching data');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No users found');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading:
                        const Icon(Icons.person, size: 40, color: Colors.blue),
                    title: Text(
                      userData['name'] ?? 'Name not available',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['email'] ?? 'Email not available',
                        ),
                        Text(
                          "Current Role: " + userData['role'] ??
                              'Role not available',
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String result) {
                        showConfirmationDialog(context, userData, result);
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'admin',
                          child: Text('Make Admin'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'user',
                          child: Text('Make User'),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle user details or navigation to a detailed user screen
                      // You can pass the user data to the next screen if needed
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showConfirmationDialog(
      BuildContext context, Map<String, dynamic> userData, String newRole) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Role Change'),
          content: Text('Are you sure you want to make ${userData['name']} an $newRole?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the role change here
                updateRole(userData, newRole);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void updateRole(Map<String, dynamic> userData, String newRole) {
    // Update user role in Firestore
    String userId = userData['userId'] ?? ''; // Replace with your user ID field
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'role': newRole,
    }).then((value) {
      // You can add additional logic after the role is successfully updated
      print('${userData['name']} role updated to $newRole');
    }).catchError((error) {
      print('Error updating role: $error');
    });
  }
}
