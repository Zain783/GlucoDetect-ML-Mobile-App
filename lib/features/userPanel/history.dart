import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Stream<QuerySnapshot> _historyStream;

  @override
  void initState() {
    super.initState();
    _historyStream = FirebaseFirestore.instance
        .collection('user_history')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
  }

  Future<void> _deleteHistoryItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_history')
          .doc(documentId)
          .delete();
    } catch (e) {
      print("Error deleting history item: $e");
    }
  }

  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this history item?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                _deleteHistoryItem(documentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: StreamBuilder(
        stream: _historyStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No history available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var historyItem = snapshot.data!.docs[index];
              var imageUrl = historyItem['imageUrl'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(), // Display an empty container if imageUrl is empty
                    ListTile(
                      title: Text('History Item #$index'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(historyItem.id);
                        },
                      ),
                    ),
                    const Divider()
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
