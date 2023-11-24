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

          return Center(
            child: ListWheelScrollView(
              itemExtent: 300,
              children: medicines.map((DocumentSnapshot document) {
                var medicine = document.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display the medicine name
                          Image.network(
                            medicine['image_url'] ?? 'No Name',
                            height: 100,
                          ),
                          Text(
                            medicine['name'] ?? 'No Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display the medicine description
                          Text(
                            medicine['description'] ?? 'No Description',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          // You can add more details if needed, e.g., image
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
