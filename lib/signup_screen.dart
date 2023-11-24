import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/Login.dart';
import 'package:glucoma_app_fyp/repository/auth_methords.dart';
import 'package:glucoma_app_fyp/utils/global_variables.dart';
import 'package:glucoma_app_fyp/widgets/rounded_btn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailtext = TextEditingController();
  final TextEditingController nametext = TextEditingController();
  final TextEditingController passwordtext = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
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
              )),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    200.h,
                    Container(
                      child: const Text(
                        "SignUp Here",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                    ),
                    Container(
                      height: 50,
                    ),

                    Container(
                      width: 350,
                      height: 60,
                      //email textfield code is here
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.blue,
                        child: TextField(
                          controller: nametext,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                    ),
                    15.h,
                    Container(
                      width: 350,
                      height: 60,
                      //email textfield code is here
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.blue,
                        child: TextField(
                          controller: emailtext,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                    ),
                    15.h,
                    //password field code is
                    Container(
                      width: 350,
                      height: 60,
                      child: Card(
                        shadowColor: Colors.blue,
                        elevation: 6,
                        child: TextField(
                          controller: passwordtext,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                    ),
                    20.h,
                    CustomButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });

                            await AuthMethods().signUpWithEmailAndPassword(
                              emailtext.text,
                              passwordtext.text,
                              nametext.text,
                              context,
                            );

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        text: "SignUp",
                        isLoading: isLoading),
                    10.h,
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Container(
                        child: const Text(
                          "already have an account? Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
