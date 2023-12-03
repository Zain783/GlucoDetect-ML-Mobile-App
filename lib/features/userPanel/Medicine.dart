import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicines"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('midicines').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> medicines = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              var medicine = medicines[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the medicine name
                        Image.network(
                          medicine['image_url'] ?? 'No Image',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          medicine['name'] ?? 'No Name',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Display the medicine description
                        Text(
                          medicine['description'] ?? 'No Description',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        // You can add more details if needed
                      ],
                    ),
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
