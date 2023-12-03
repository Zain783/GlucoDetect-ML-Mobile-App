import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucoma_app_fyp/repository/upload_detection_image.dart';
import 'package:glucoma_app_fyp/utils/global_variables.dart';
import 'package:glucoma_app_fyp/utils/utils.dart';
import 'package:glucoma_app_fyp/widgets/rounded_btn.dart';

class DetectGlucoma extends StatelessWidget {
  // Placeholder function for glaucoma detection
  void detectGlucoma(String imageUrl) {
    // Replace this with your actual glaucoma detection logic
    // You might want to call a backend API or perform image processing here
    // For now, let's just print a message
    print('Detecting glaucoma for image: $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Glucoma"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('detection_history')
            .snapshots(),
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
                        Image.network(
                          medicine['image_url'] ?? 'No Image',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Glucoma Detection: "),
                            Text(
                              medicine['prediction'] == ""
                                  ? "NAN"
                                  : medicine['prediction'],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        20.h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              onPressed: () async {
                                try {
                                  await preditionApi(
                                      medicine['image_url'], context);
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  Utils.errorSnakbar(context, e.toString());
                                }
                              },
                              text: "Detect Glaucoma",
                              isLoading: false,
                            ),
                          ],
                        ),
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
