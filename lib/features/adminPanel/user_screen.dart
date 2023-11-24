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
            )),
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
                    subtitle: Text(
                      userData['email'] ?? 'Email not available',
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
}
