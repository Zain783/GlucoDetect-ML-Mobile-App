import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glucoma_app_fyp/Login.dart';
import 'package:glucoma_app_fyp/features/userPanel/Medicine.dart';
import 'package:glucoma_app_fyp/features/userPanel/Settings.dart';
import 'package:glucoma_app_fyp/features/userPanel/detetction.dart';
import 'package:glucoma_app_fyp/features/userPanel/image.dart';
import 'package:glucoma_app_fyp/firebase_options.dart';
import 'package:glucoma_app_fyp/utils/global_variables.dart';
import 'package:glucoma_app_fyp/widgets/custom_card.dart';
import 'features/adminPanel/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return checkUserType();
          }
          return const CircularProgressIndicator();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget checkUserType() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No user signed in, navigate to login screen
      return Login();
    } else {
      // Fetch user data from Firestore
      // Replace 'yourUsersCollection' with the actual collection name for user data
      return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var userRole = userData['role'] ?? '';

            if (userRole == 'admin') {
              // User is an admin, navigate to admin dashboard
              return const DashboardScreen();
            } else {
              // User is not an admin, navigate to user home screen
              return const MyHomePage(title: '');
            }
          }

          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        },
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List imageList = [
    {"id": 1, "image_path": 'assets/images/test2.jpg'},
    {"id": 2, "image_path": 'assets/images/eye1.jpg'},
    {"id": 3, "image_path": 'assets/images/eye_image_1.jpeg'}
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF73AEF5).withOpacity(0.1),
                const Color(0xFF61A4F1).withOpacity(0.3),
              ],
              stops: const [
                0.1,
                0.3,
              ],
            ),
          ),
          child: Column(
            children: [
              30.h,
              Container(
                height: 80,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(80))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hi, Hassan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // You can add a profile image or other elements here
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 210,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        print(currentIndex);
                      },
                      child: CarouselSlider(
                        items: imageList
                            .map(
                              (item) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage(item['image_path']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: 310,
                          enlargeCenterPage: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 0.9,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 9.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: currentIndex == entry.key
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              15.h,
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: "Camera",
                      icon: Icons.linked_camera,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiseaseDetectionApp()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: CustomCard(
                    title: "Gallery",
                    icon: Icons.photo_library,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiseaseApp()),
                      );
                    },
                  )),
                  Expanded(
                    child: CustomCard(
                      title: "History",
                      icon: Icons.history,
                      onTap: () {},
                    ),
                  )
                ],
              ),
              10.h,
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: "Doctor",
                      icon: Icons.location_history_sharp,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: CustomCard(
                      title: "Medicine",
                      icon: Icons.medical_services,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Medicine()));
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomCard(
                      title: "Settings",
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                    ),
                  )
                ],
              ),
              300.h
            ],
          ),
        ),
      ),
    );
  }
}
